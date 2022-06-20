import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCustom extends StatefulWidget {
  const WebViewCustom({Key? key}) : super(key: key);

  @override
  WebViewCustomState createState() => WebViewCustomState();
}

class WebViewCustomState extends State<WebViewCustom> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
          'https://www.google.com/maps/search/?api=1&query=13.816969803749302,100.56088531534392',
    );
  }
}
