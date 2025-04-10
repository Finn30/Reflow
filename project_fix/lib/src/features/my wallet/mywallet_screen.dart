import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/bank%20card/bankcard_screen.dart';
import 'package:project_fix/src/features/my%20wallet/coupon/coupon_screen.dart';
import 'package:project_fix/src/features/my%20wallet/recharge/recharge_screen.dart';
import 'package:project_fix/src/features/my%20wallet/refund/refund_screen.dart';
import 'package:project_fix/src/features/my%20wallet/ride%20pass/ridepass_screen.dart';
import 'package:project_fix/src/function/services.dart';

class MyWalletScreen extends StatelessWidget {
  final FirestoreService fs = FirestoreService();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16.0), // Tambah padding agar tidak mentok ke bawah
          child: Column(
            children: [
              _buildBalanceCard(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RidePassScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon berbentuk mahkota VIP
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons
                                    .verified, // Gantilah dengan ikon yang lebih sesuai
                                color: Colors.orange,
                                size: 40.0,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            // Teks utama
                            Text(
                              'Get VIP membership, save\nmore monthly',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        // Ikon panah ke kanan
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildWalletOption(
                context,
                icon: Icons.credit_card,
                title: 'Bank Card',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BankCardScreen()),
                ),
              ),
              _buildWalletOption(
                context,
                icon: Icons.refresh,
                title: 'Recharge',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RechargeScreen()),
                ),
              ),
              _buildWalletOption(
                context,
                icon: Icons.discount,
                title: 'Coupon',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CouponScreen()),
                ),
              ),
              _buildWalletOption(
                context,
                icon: Icons.compare_arrows,
                title: 'Refund',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RefundScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.white),
                SizedBox(width: 8.0),
                Text('Current Balance',
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ],
            ),
            SizedBox(height: 16.0),
            FutureBuilder<int?>(
              future: fs.getBalance(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rp',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(width: 2.0),
                    Text(snapshot.data?.toString() ?? "0",
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('(including Rp 0 gift)',
                    style: TextStyle(fontSize: 12.0, color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWalletOption(BuildContext context,
      {required IconData icon,
      required String title,
      Color color = Colors.grey,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black, size: 35.0),
                  SizedBox(width: 8.0),
                  Text(title, style: TextStyle(fontSize: 16.0)),
                ],
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
