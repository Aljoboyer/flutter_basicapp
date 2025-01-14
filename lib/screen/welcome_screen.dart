import 'package:basic_phase_app/helper/localstorage_fun.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final LocalStorageService storage = LocalStorageService();

  logOutHandler () async {
    var user_email = await storage.deleteData('user_email');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Column(
        children: [
          const Text('Hi There'),
          TextButton(onPressed: logOutHandler, child: const Text('LogOut--->'))
        ],
      ),
    );
  }
}
