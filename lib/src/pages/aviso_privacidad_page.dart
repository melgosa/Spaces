import 'package:flutter/material.dart';
import 'package:monitor_ia/src/widgets/app_bar_principal.dart';
import 'package:monitor_ia/src/widgets/webview_widget.dart';

class AvisoPrivacidadPage extends StatefulWidget {
  const AvisoPrivacidadPage({Key key}) : super(key: key);

  @override
  _AvisoPrivacidadPageState createState() => _AvisoPrivacidadPageState();
}

class _AvisoPrivacidadPageState extends State<AvisoPrivacidadPage> {

  String url = 'http://gh-back2work.s3-website-us-east-1.amazonaws.com/';
  //String url = 'https://firebase.google.com/docs/cloud-messaging/ios/client#method_swizzling_in_firebase_messaging';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPrincipal('Aviso de privacidad', true, context, Color.fromRGBO(189, 48, 48 , 1)),
        body: WebViewWidget(url)
    );
  }
}
