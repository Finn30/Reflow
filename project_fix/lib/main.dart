import 'package:flutter/material.dart';
import 'package:project_fix/src/features/welcome%20screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_fix/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load environment variables first
  WidgetsFlutterBinding.ensureInitialized();

  // Mobile
  await Firebase.initializeApp();

  // Web
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VehicleNumberProvider()),
      ],
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
