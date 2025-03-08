import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarGuideScreen extends StatelessWidget {
  const CarGuideScreen({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Guide'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reflow E-Bike User Guide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Reflow. Follow this guide for a smoother and more convenient riding experience.',
              ),
              const SizedBox(height: 20),
              buildGuideSection(
                '1. Reflow Account Registration',
                'Before starting your ride, make sure you have a Reflow account. Follow the simple steps in this video:',
                'https://youtube.com/shorts/gA6kpBy2w78',
                _launchURL,
              ),
              buildGuideSection(
                '2. How to Use Reflow E-Bike',
                'Ready to ride? Here’s how to unlock and use the e-bike properly:',
                'https://youtube.com/shorts/bXR-yeH78ag',
                _launchURL,
              ),
              buildGuideSection(
                '3. Gridwiz E-Bike Pause Guide',
                'Make sure to pause the e-bike in the correct location to properly end your trip. Check the parking guide here:',
                'https://youtube.com/shorts/qeijvYJ54T8',
                _launchURL,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGuideSection(
      String title, String description, String url, Function(String) onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => onTap(url),
            child: Text(
              url,
              style: const TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
