import 'package:flutter/material.dart';
import 'package:project_fix/src/features/welcome/welcome_screen.dart';
import 'package:project_fix/src/utils/theme/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: WelcomeScreen());
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        leading: const Icon(Icons.ondemand_video),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart_outlined),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Heading", style: Theme.of(context).textTheme.headlineMedium),
            Text("Sub Heading", style: Theme.of(context).textTheme.titleMedium),
            Text("Paragraph", style: Theme.of(context).textTheme.bodySmall),
            ElevatedButton(
                onPressed: () {}, child: const Text('Elevad Button')),
            OutlinedButton(
                onPressed: () {}, child: const Text('Outlined Button')),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Image(image: AssetImage("assets/img/gridwiz.jpg")),
            ),
          ],
        ),
      ),
    );
  }
}
