import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/recharge/recharge_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const MidtransPaymentScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<MidtransPaymentScreen> createState() => _MidtransPaymentScreen();
}

class _MidtransPaymentScreen extends State<MidtransPaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains("status=success")) {
              Navigator.pop(context, "success");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RechargeScreen()));
            } else if (url.contains("status=failed")) {
              Navigator.pop(context, "failed");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran Midtrans")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
