import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/mywallet_screen.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MidtransPaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final int amount;


  const MidtransPaymentScreen({Key? key, required this.paymentUrl, required this.amount})
      : super(key: key);

  @override
  State<MidtransPaymentScreen> createState() => _MidtransPaymentScreen();
}

class _MidtransPaymentScreen extends State<MidtransPaymentScreen> {
  late final WebViewController _controller;
  final FirestoreService fs = FirestoreService();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate (
          onPageFinished: (String url) async{
            if (url.contains("example.com")) {
              await fs.topUpFirebase(uid, widget.amount);
              _navigateToRechargeScreen();
            } else if (url.contains("status=failed")) {
              Navigator.pop(context, "failed");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _navigateToRechargeScreen() {
    Future.microtask(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyWalletScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran Midtrans")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
