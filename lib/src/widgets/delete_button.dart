import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Necesitamos escuchar el loading y el selectedType por eso un consumer, igual que en scanTile utilizamos 
		/// Tambien el listenable de Hive para poder utilizar uno u otro cambiando unas pocas lineas
    return Consumer<ScansProvider>(
      builder: (context, scansProvider, _) {         
        return ValueListenableBuilder<Box<Scan>>(
          valueListenable: context.read<HiveApi>().scansBox.listenable(), 
          builder: (context, box, _) { 
            final type = scansProvider.selectedType;

            // final scans = context.read<ScansProvider>().scansMap[type]!;
            final scans = box.values.where((scan) => scan.tipo == type).toList();
      
            return IconButton(
              onPressed: scans.isEmpty ? null : () async {
                final delete = await Notifications.showDeleteDialog();

                if(delete){
                  // final error = await context.read<ScansProvider>().deleteScansByType(type);
                  final error = await context.read<HiveApi>().deleteScanByType(type);

                  if(error != null) Notifications.showSnackBar(error);
                }
              }, 
              icon: const Icon(Icons.delete_forever)
            );
          }
        );
      },
    );
  }
}