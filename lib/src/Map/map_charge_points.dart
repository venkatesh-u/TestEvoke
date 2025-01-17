import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_in_app_purchase/src/InAppPurchase/in_app_billing.dart';
import 'chargePoints.dart' as chargePoints;
import 'custom_info_widget.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

// void main() => runApp(MyApp());

//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}


// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Easyevoke',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: "/",
//       routes: {
//         "/": (context) => HomePage(),
//         "/chargePoint": (context) => ChargePointDetail(),
//       },
//     );
//   }
// }


class MapChargePoints extends StatefulWidget {
  @override
  _MapChargePointsState createState() => _MapChargePointsState();
}

class _MapChargePointsState extends State<MapChargePoints> {

  var _isVisible;
  @override
  initState(){
    super.initState();
    setState(() {
      _isVisible = true;
    });
  }

  GoogleMapController _mapController;

  LatLng _center = LatLng(17.7324687,83.3040957);
  final Map<String, Marker> _markers = {};
  var _currentLocation ;
  String error;
  Location _locationService = new Location();
  InfoWidgetRoute _infoWidgetRoute;
  StreamSubscription _mapIdleSubscription;
  Future<LocationData> getCurrentLocation() async {
    try {

       final googleOffices = await chargePoints.getChargePoints();
       debugPrint('datasss: $googleOffices Hello');
        log('datasss: $googleOffices');
      _currentLocation = await _locationService.getLocation();
      _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
    }
  }
  //https://stackoverflow.com/questions/54104178/flutter-custom-google-map-marker-info-window
  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    await getCurrentLocation();
    final googleOffices = await chargePoints.getChargePoints();
    setState(() {
      _markers.clear();
      for (final cp in googleOffices) {
        final marker = Marker(
          markerId: MarkerId(cp.chargePointID),
          position: LatLng(cp.lat, cp.lon),
          onTap: () => _onTap(cp),
          // infoWindow: InfoWindow(
          //   title: "t.name",
          //   onTap: () {
          //     // InfoWindow clicked
          //     _showToast(context);

          // })
        );
        _markers[cp.chargePointID] = marker;
      }
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(36.972866,-86.4901743), zoom: 8.0, bearing:45.0, tilt:45.0 )));
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


  _onTap(chargePoints.ChargePoint point) async {
    final RenderBox renderBox = context.findRenderObject();
    Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _infoWidgetRoute = InfoWidgetRoute(
      cp: point,
      buildContext: context,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      mapsWidgetSize: _itemRect,
    );

    Navigator.of(context, rootNavigator: true)
        .push(_infoWidgetRoute)
        .then<void>(
          (newValue) {
        _infoWidgetRoute = null;
      },
    );

    if(_isVisible==true){
        setState(() {
          _isVisible=false;
        });
    }else{
        setState(() {
          _isVisible=true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[200],
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 7.0,
          ),
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          zoomGesturesEnabled: true,
          markers: _markers.values.toSet(),
        ),
      ),
      floatingActionButton:new Visibility( 
        visible: _isVisible,
        child: FloatingActionButton.extended(
          onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InAppPurchaseScreen(),
              ));
          },
          label: Text("Continue"),
          icon: Icon(Icons.navigate_next),
        )
      ),
    );
  }
}