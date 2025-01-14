import 'package:basic_phase_app/helper/localstorage_fun.dart';
import 'package:flutter/material.dart';

class LonginView extends StatefulWidget {
  const LonginView({super.key});

  @override
  State<LonginView> createState() => _LonginViewState();
}

class _LonginViewState extends State<LonginView> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  final storage = LocalStorageService();

  @override
  void initState() {
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }
  
  void login_handler () async {
    final email = _emailcontroller.text;
    await storage.saveData('user_email', email);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),
      ),
      body: FutureBuilder(
        future: Future(() => {
          
        },),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return  Column(
                children: [
                  TextField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email'
                    ),
                  ),
                  TextField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password'
                    ),
                  ),
                  TextButton(onPressed: () {
                   login_handler();
                  }, child: const Text('Login')),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);
                  }, child: Text("Not Registered Yet? Register Here!"))
                ],
           );;
            default:
              return Text('Loadding....', selectionColor: Colors.red,);
          }
        },
      ),
    );
  }
}