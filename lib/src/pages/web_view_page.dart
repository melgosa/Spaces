import 'package:monitor_ia/src/widgets/app_bar_principal.dart';
import 'package:monitor_ia/src/widgets/webview_widget.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  WebViewPage(this.title, this.url, {Key key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarPrincipal(widget.title, true, context, Color.fromRGBO(84, 110, 122 , 1)),
        ),
        body: WebViewWidget(widget.url)
    );
  }
}
