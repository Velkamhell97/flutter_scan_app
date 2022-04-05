import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../services/services.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  Future<void> _deleteScans(BuildContext context) async {
    final delete = await showDialog<bool>(
      context: context, 
      builder: (_) => CustomDialog()
    ) ?? false;

    if(delete){
      final error = await context.read<ScansProvider>().deleteActiveScans();

      if(error != null) {
        Notifications.showSnackBar(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scans = context.watch<ScansProvider>().activeScans;
    // print('build delete button');

    return IconButton(
      onPressed: scans.isEmpty ? null : () => _deleteScans(context) , 
      icon: Icon(Icons.delete_forever)
    );
  }
}