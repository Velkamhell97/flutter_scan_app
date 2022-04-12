import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class Notifications {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<bool> showDeleteDialog() async{
    return await showDialog<bool>(
      context: navigatorKey.currentContext!, 
      builder: (_) => const DeleteDialog()
    ) ?? false;
  }

  static Future<void> showSnackBar(String message) async{
    messengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}