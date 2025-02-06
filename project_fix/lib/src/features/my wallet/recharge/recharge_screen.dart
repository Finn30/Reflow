import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/recharge/midtrans%20payment/midtranspayment_screen.dart';
import 'package:project_fix/src/function/services.dart';

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int selectedCardIndex = -1;
  bool isCheckboxChecked = false;
  FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  List<Map<String, String>> rechargeAmounts = [
    {"amount": "1000", "gift": "Gift Rp0"},
    {"amount": "5000", "gift": "Gift Rp0"},
    {"amount": "10000", "gift": "Gift Rp0"},
    {"amount": "15000", "gift": "Gift Rp0"},
    {"amount": "20000", "gift": "Gift Rp0"},
    {"amount": "30000", "gift": "Gift Rp0"},
    {"amount": "50000", "gift": "Gift Rp1000"},
    {"amount": "100000", "gift": "Gift Rp2000"},
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Recharge online",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildBalanceCard(),
              SizedBox(height: 10),
              _buildRechargeOptions(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomContainer(),
    );
  }

  Widget _buildBalanceCard() {
    return FutureBuilder<int?>(
      future: fs.getBalance(uid), // Panggil fungsi async
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Tampilkan loading
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Balance not available"));
        }else{
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(), // Tampilkan nilai balance
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Text("Balance (Rp)",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Bonus Amount:\t\tRp0",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Principal:\t\tRp0",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRechargeOptions() {
    List<Map<String, String>> rechargeAmounts = [
      {"amount": "1000", "gift": "Gift Rp0"},
      {"amount": "5000", "gift": "Gift Rp0"},
      {"amount": "10000", "gift": "Gift Rp0"},
      {"amount": "15000", "gift": "Gift Rp0"},
      {"amount": "20000", "gift": "Gift Rp0"},
      {"amount": "30000", "gift": "Gift Rp0"},
      {"amount": "50000", "gift": "Gift Rp1000"},
      {"amount": "100000", "gift": "Gift Rp2000"},
    ];

    return Column(
      children: [
        for (int i = 0; i < rechargeAmounts.length; i += 2)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRechargeCard(i, rechargeAmounts[i]["amount"]!,
                    rechargeAmounts[i]["gift"]!),
                _buildRechargeCard(i + 1, rechargeAmounts[i + 1]["amount"]!,
                    rechargeAmounts[i + 1]["gift"]!),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRechargeCard(int index, String amount, String gift) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color:
                selectedCardIndex == index ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: 170,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: selectedCardIndex == index
                              ? Colors.blue
                              : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: selectedCardIndex == index
                              ? Colors.blue
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 24,
                alignment: Alignment.center,
                color:
                    selectedCardIndex == index ? Colors.blue : Colors.grey[300],
                child: Text(
                  gift,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: selectedCardIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContainer() {
    bool isTopUpEnabled = selectedCardIndex != -1 && isCheckboxChecked;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet,
                        color: Colors.blue, size: 24),
                    SizedBox(width: 8.0),
                    Text(
                      "Midtrans",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCheckboxChecked = !isCheckboxChecked;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isCheckboxChecked
                              ? Colors.blue
                              : Colors.grey[500]!),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCheckboxChecked
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isTopUpEnabled
                    ? () {
                        fs.createPaymentLinkMidtrans(email, int.parse(rechargeAmounts[selectedCardIndex]["amount"]!)).then((link) {
                          if (link != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MidtransPaymentScreen(
                                        paymentUrl: link, amount: int.parse(rechargeAmounts[selectedCardIndex]["amount"]!))));
                          } else {
                            // Handle the case where link is null
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Failed to create payment link')));
                          }
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTopUpEnabled ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  "Top up now",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
