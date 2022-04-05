import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../services/services.dart';

class HiveDeleteButton extends StatelessWidget {
  const HiveDeleteButton({Key? key}) : super(key: key);

  Future<void> _deleteScans(BuildContext context, String type) async {
    final delete = await showDialog<bool>(
      context: context, 
      builder: (_) => CustomDialog()
    ) ?? false;

    if(delete){
      final error = await context.read<HiveApi>().deleteScanByType(type);

      if(error != null) {
        Notifications.showSnackBar(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = context.watch<HiveScansProvider>().selectedType;
    // print('delete button build');

    return ValueListenableBuilder<Box<HiveScanModel>>(
      valueListenable: context.read<HiveApi>().scansBox.listenable(), 
      builder: (context, box, _) {
        final scans = box.values.where((scan) => scan.tipo == type).toList();

        return IconButton(
          onPressed: scans.isEmpty ? null : () => _deleteScans(context, type), 
          icon: Icon(Icons.delete_forever)
        );
      }
    );
  }
}