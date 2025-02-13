import 'package:basic_phase_app/constants/routes.dart';
import 'package:basic_phase_app/helper/localstorage_fun.dart';
import 'package:basic_phase_app/services/note/notes_service.dart';
import 'package:flutter/material.dart';

enum ManuAction {logout}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final storage = LocalStorageService();
  late final NotesService _notesService;

  void logout_handler (islogout) async {
    if(islogout == 'true'){
      await storage.deleteData('user_email');
     Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  void initState(){
    final _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose(){
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(newNotesRoute, (route) => false,);
          }, icon: Icon(Icons.add)),
          PopupMenuButton<ManuAction>(onSelected: (value) async {
            switch (value) {
              case ManuAction.logout:
                final shouldlogout = await showLogoutModal(context);
                logout_handler(shouldlogout.toString());
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
      body: SizedBox(
        
      )
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