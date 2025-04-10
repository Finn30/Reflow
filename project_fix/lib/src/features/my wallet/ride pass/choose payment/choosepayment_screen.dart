import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/recharge/midtrans%20payment/midtranspayment_screen.dart';
import 'package:project_fix/src/function/services.dart';

class ChoosePaymentScreen extends StatefulWidget {
  final int price;
  final int balance;

  const ChoosePaymentScreen(
      {Key? key, required this.price, required this.balance})
      : super(key: key);

  @override
  _ChoosePaymentScreenState createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String? selectedPaymentMethod;

  void _handlePayment() async {
    if (selectedPaymentMethod == 'Balance') {
      if (widget.balance >= widget.price) {
        _showConfirmationDialog();
      } else {
        _showInsufficientBalanceAlert();
      }
    } else if (selectedPaymentMethod == 'Midtrans') {
      // Ambil email pengguna dari FirebaseAuth
      String email = FirebaseAuth.instance.currentUser?.email ?? "";

      if (email.isNotEmpty) {
        FirestoreService fs = FirestoreService();
        String? paymentUrl =
            await fs.createPaymentLinkMidtrans(email, widget.price);

        if (paymentUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MidtransPaymentScreen(
                paymentUrl: paymentUrl,
                amount: widget.price,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membuat link pembayaran.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User tidak ditemukan.')),
        );
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content:
            const Text('Are you sure you want to proceed with this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processBalancePayment();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showInsufficientBalanceAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Balance tidak cukup')),
    );
  }

  void _processBalancePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful using Balance')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Payment Order'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'To be paid',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rp${widget.price}',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Order number: 1901552168898244609',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Choose the payment method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            _buildPaymentOption('Balance', Icons.account_balance_wallet),
            _buildPaymentOption('Midtrans', Icons.payment),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedPaymentMethod != null ? _handlePayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedPaymentMethod != null
                  ? Colors.blue
                  : Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text('To Pay',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(icon, size: 24, color: Colors.blue),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
            ]),
            Icon(
              selectedPaymentMethod == title
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selectedPaymentMethod == title ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
