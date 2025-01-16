import 'package:flutter/material.dart';

enum ManuAction {logout}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<ManuAction>(onSelected: (value) async {
            switch (value) {
              case ManuAction.logout:
                final shouldlogout = await showLogoutModal(context);
                print(shouldlogout.toString());
                break;
              default:
            }
          }, itemBuilder: (context) {
           return [
             const PopupMenuItem<ManuAction>(value: ManuAction.logout, child: Text('Logout')),
           ];
          },)
        ],
      ),
      body: Text('Notes'),
    );
  }
}

Future<bool>showLogoutModal(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to logout'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: Text('Yes'))
        ],
      );
    },
  ).then((value) => value ?? false);
}