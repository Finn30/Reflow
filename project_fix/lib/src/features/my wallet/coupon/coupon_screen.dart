import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Unused'),
                Tab(text: 'Used'),
              ],
              labelColor: Colors.blue, // Active tab color
              unselectedLabelColor: Colors.grey, // Inactive tab color
              indicatorColor: Colors.blue, // Underline color for active tab
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Unused Coupons')),
                  Center(child: Text('Used Coupons')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
