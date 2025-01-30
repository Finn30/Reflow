import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/bank%20card/bankcard_screen.dart';
import 'package:project_fix/src/features/my%20wallet/coupon/coupon_screen.dart';
import 'package:project_fix/src/features/my%20wallet/recharge/recharge_screen.dart';

class MyWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Wallet'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
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
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8.0),
                        Text('Rp',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 2.0),
                        Text('0',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8.0),
                        Text('(including Rp 0 gift)',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Bank Card
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankCardScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.credit_card,
                                  color: Colors.black, size: 35.0),
                              SizedBox(width: 8.0),
                              Text('Bank Card',
                                  style: TextStyle(fontSize: 18.0)),
                            ],
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Recharge
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RechargeScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.refresh,
                                  color: Colors.black, size: 35.0),
                              SizedBox(width: 8.0),
                              Text('Recharge',
                                  style: TextStyle(fontSize: 18.0)),
                            ],
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Coupon
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CouponScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.discount,
                                  color: Colors.black, size: 35.0),
                              SizedBox(width: 8.0),
                              Text('Coupon', style: TextStyle(fontSize: 18.0)),
                            ],
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
