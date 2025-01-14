import 'package:flutter/material.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

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
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'),
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
                    decoration: const InputDecoration(
                      hintText: 'Enter your email'
                    ),
                  ),
                  TextField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password'
                    ),
                  ),
                  TextButton(onPressed: () {
                    final email = _emailcontroller.text;
                    final password = _passwordcontroller.text;
                  }, child: const Text('Register')),
                   TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }, child: Text("Already have an account? Login Here!"))
                ],
           );;
            default:
              return const Text('Loadding....', selectionColor: Colors.red,);
          }
        },
      ),
    );
  }
}
