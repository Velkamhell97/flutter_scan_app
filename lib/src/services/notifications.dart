import 'package:flutter/material.dart';

// import '../widgets/widgets.dart';

class DialogModel {
  final IconData icon;
  final String title;
  final String body;
  final String mainButton;
  final String? secondaryButton;

  const DialogModel({required this.icon, required this.title, required this.body, required this.mainButton, this.secondaryButton});
}

class Notifications {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  // static Future<bool> _dialogBuilder(BuildContext context, DialogModel dialog) async {
  //   return await showGeneralDialog<bool>(
  //     context: context, 
  //     pageBuilder: (context, animation, _) => SlideTransition(
  //       position: Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0)).animate(animation),
  //       child: ErrorDialog(dialog: dialog),
  //     ),
  //   ) ?? false;
  // }

  static Future<void> showSnackBar(String message) async{
    messengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}