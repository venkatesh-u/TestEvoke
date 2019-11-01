import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'chargePoints.dart' as chargePoints;
class _InfoWidgetRouteLayout<T> extends SingleChildLayoutDelegate {
  final Rect mapsWidgetSize;
  final double width;
  final double height;

  _InfoWidgetRouteLayout(
      {@required this.mapsWidgetSize,
        @required this.height,
        @required this.width});

  /// Depending of the size of the marker or the widget, the offset in y direction has to be adjusted;
  /// If the appear to be of different size, the commented code can be uncommented and
  /// adjusted to get the right position of the Widget.
  /// Or better: Adjust the marker size based on the device pixel ratio!!!!)

  @override
  Offset getPositionForChild(Size size, Size childSize) {
//    if (Platform.isIOS) {
    return Offset(
      mapsWidgetSize.center.dx - childSize.width / 2,
      mapsWidgetSize.center.dy - childSize.height - 50,
    );
//    } else {
//      return Offset(
//        mapsWidgetSize.center.dx - childSize.width / 2,
//        mapsWidgetSize.center.dy - childSize.height - 10,
//      );
//    }
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //we expand the layout to our predefined sizes
    return BoxConstraints.expand(width: width, height: height);
  }

  @override
  bool shouldRelayout(_InfoWidgetRouteLayout oldDelegate) {
    return mapsWidgetSize != oldDelegate.mapsWidgetSize;
  }
}

class InfoWidgetRoute extends PopupRoute {
  Widget child;
  final double width;
  final double height;
  final BuildContext buildContext;
  final TextStyle textStyle;
  final Rect mapsWidgetSize;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  InfoWidgetRoute({
    chargePoints.ChargePoint cp,
    @required this.buildContext,
    @required this.textStyle,
    @required this.mapsWidgetSize,
    this.width = 350,
    this.height = 200,
    this.barrierLabel,
  }){
    this.child = Text(
        'Hello,  How are you?',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    String htmlText =getHTML(cp);
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(htmlText));
    String url = 'data:text/html;base64,$contentBase64';
    this.child = WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>[
          _cpJavascriptChannel(buildContext,cp),
          ].toSet(),
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {return NavigationDecision.prevent;}
    );
  }

  JavascriptChannel _cpJavascriptChannel(BuildContext context, chargePoints.ChargePoint cp) {
    return JavascriptChannel(
        name: 'ChargePoint',
        onMessageReceived: (JavascriptMessage message) {
          Navigator.of(buildContext).pushReplacementNamed('/chargePoint',arguments: {'cp':cp,'connector':message.message});
        });
  }

    void _showToast(BuildContext context) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Added to favorite'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

//  JavascriptChannel _cpJavascriptChannel(BuildContext context, ChargePoint cp) {
//    return JavascriptChannel(
//        name: 'ChargePoint',
//        onMessageReceived: (JavascriptMessage message) {
//          Navigator.of(buildContext).pushReplacementNamed('/chargePoint',arguments: cp);
//        });
//  }

  String getHTML(chargePoints.ChargePoint cp){
    String connTRs = '<tr style="background-color:#b0b0b0"><td>Connector Type</td><td>Available</td><td>Occupied</td><td>price</td></tr>';

    cp.connectors.forEach((key, conn) =>
      {
        connTRs += '''
          <tr>
            <td>${key}</td>
            <td>${conn.available}</td>
            <td>${conn.occupied}</td>
            <td onclick="ChargePoint.postMessage ('${key}');">${conn.price}</td>
          </tr>'''
      });


    String retVal ='''
      <a href="app://${cp.chargePointID}"> ${cp.chargePointID} </a>
      <table border="1">
          ${connTRs}
      </table>
    ''';

    return retVal;
  }


  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: Builder(builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _InfoWidgetRouteLayout(
              mapsWidgetSize: mapsWidgetSize, width: width, height: height),
          child: InfoWidgetPopUp(
            infoWidgetRoute: this,
          ),
        );
      }),
    );
  }
}

class InfoWidgetPopUp extends StatefulWidget {
  const InfoWidgetPopUp({
    Key key,
    @required this.infoWidgetRoute,
  })  : assert(infoWidgetRoute != null),
        super(key: key);

  final InfoWidgetRoute infoWidgetRoute;

  @override
  _InfoWidgetPopUpState createState() => _InfoWidgetPopUpState();
}

class _InfoWidgetPopUpState extends State<InfoWidgetPopUp> {
  CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.infoWidgetRoute.animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Material(
        type: MaterialType.transparency,
        textStyle: widget.infoWidgetRoute.textStyle,
        child: ClipPath(
          clipper: _InfoWidgetClipper(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 10),
            child: Center(child: widget.infoWidgetRoute.child),
            
          ),
        ),
      ),
    );
  }
}

class _InfoWidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(0.0, size.height - 10, 10.0, size.height - 10);
    path.lineTo(size.width / 2 - 10, size.height - 10);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 10, size.height - 10);
    path.lineTo(size.width - 10, size.height - 10);
    path.quadraticBezierTo(
        size.width, size.height - 10, size.width, size.height - 20);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}