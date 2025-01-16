import 'package:basic_phase_app/helper/localstorage_fun.dart';
import 'package:basic_phase_app/screen/login_screen.dart';
import 'package:basic_phase_app/screen/notes_view.dart';
import 'package:basic_phase_app/screen/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(248, 9, 252, 139)),
        useMaterial3: true,
      ),
      home:  HomePage(),
      routes: {
        '/login': (context) => LonginView(),
        '/register': (context) => RegisterView(),
        '/notes': (context) => Notes()
      },
    ));
}

class HomePage extends StatelessWidget {
  final LocalStorageService storage = LocalStorageService();

  Future<bool> checkUser() async {
    var user_email = await storage.getData('user_email');
    
    return user_email != null && user_email.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            return const Notes();
          } else {
            return const LonginView(); // Placeholder widget while navigation occurs
          }
        },
      ),
    );
  }
}
