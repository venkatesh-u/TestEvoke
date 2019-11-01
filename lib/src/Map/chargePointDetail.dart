
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chargePoints.dart' as chargePoints;


class ChargePointDetail extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<ChargePointDetail> {
  chargePoints.ChargePoint chargePoint = null;
  String connector = null;
  var args = null;
  WebViewController _webViewController;
  String htmlText = null;
  final Completer<WebViewController> _completer =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    //htmlText = await getHTML(this.chargePoint);
    this.args = ModalRoute.of(context).settings.arguments;
    this.chargePoint = args['cp'];
    this.connector   = args['connector'];
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChargePoint'),

        ),

        body: Builder(builder: (BuildContext context) {

          //final String contentBase64 = base64Encode(const Utf8Encoder().convert(htmlText));
          //String url = 'file:///assets/cpDetails.html';//'data:text/html;base64,$contentBase64';

          return WebView(
            initialUrl: '',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) async {
              _webViewController= webViewController;
              await loadHtmlFromAssets('assets/cpDetails.html', _webViewController);
              _completer.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              _cpJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {return NavigationDecision.prevent; },
            onPageFinished: (String url) {
              //print('Page finished loading: $url');
              var price = this.chargePoint.connectors[this.connector].price;
              String js = "setConnector('${this.chargePoint.chargePointID}','${this.connector}', ${price})";
              _webViewController.evaluateJavascript (js);
            },
          );
        })
    );
  }

  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await DefaultAssetBundle.of(context).loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  JavascriptChannel _cpJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'ChargePoint',
        onMessageReceived: (JavascriptMessage message) {
          // We will make an InApp purchase here and if the purchase is successful
          // then we make a Rest API call and then switch to a page that shows
          // Charge progress.
          print('HELLO'+message.message);
        });
  }

}