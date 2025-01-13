import 'package:basic_phase_app/helper/localstorage_fun.dart';
import 'package:basic_phase_app/screen/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(249, 255, 255, 255)),
        useMaterial3: true,
      ),
      home:  HomePage(),
    ));
}

class HomePage extends StatelessWidget {
  final LocalStorageService storage = LocalStorageService();

  Future<bool> checkUser() async {
    var user_email = await storage.getData('user_email');
    print('user_email: $user_email');
    return user_email != null && user_email.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkUser(), // Call your async function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Text('Loading...');// Show a loading indicator while waiting
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            // User is logged in
            return const Center(child: Text('User Logged In'));
          } else {
            // User is not logged in
            return const LonginView();
          }
        },
      ),
    );
  }
}
