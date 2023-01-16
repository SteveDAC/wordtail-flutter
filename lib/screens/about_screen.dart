import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    Wakelock.disable();
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'WordTail',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('v1.0'),
            SizedBox(height: 25),
            Text(
              'Copyright ©2023 Steve Clarke.',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
