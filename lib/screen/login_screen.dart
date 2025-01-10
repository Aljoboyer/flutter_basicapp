import 'package:flutter/material.dart';


class LonginView extends StatefulWidget {
  const LonginView({super.key});

  @override
  State<LonginView> createState() => _LonginViewState();
}

class _LonginViewState extends State<LonginView> {
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
      appBar: AppBar(title: Text('Register'),
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
                    final email = _emailcontroller.text;
                    final password = _passwordcontroller.text;
                  }, child: const Text('Register')),
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