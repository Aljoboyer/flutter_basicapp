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
              Future.microtask(() {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const VerifiedEmailView(),
                    ),
                  );
                });
            return const SizedBox();
          } else {
            return const LonginView(); // Placeholder widget while navigation occurs
          }
        },
      ),
    );
  }
}

class VerifiedEmailView extends StatefulWidget {
  const VerifiedEmailView({super.key});

  @override
  State<VerifiedEmailView> createState() => _VerifiedEmailViewState();
}

class _VerifiedEmailViewState extends State<VerifiedEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        
      ),
    );
  }
}
