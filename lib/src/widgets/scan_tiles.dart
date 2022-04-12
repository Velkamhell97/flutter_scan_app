import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// El consumer es para escuchar los cambios del provider (selectedType y loading)
    return Consumer<ScansProvider>(
      builder: (_, scansProvider, __) {
        /// El error y loading sirve principalmente para sfqlite ya que Hive utiliza el listenable
        if(scansProvider.error != null) {
          return Center(child: Text(scansProvider.error!));
        }

        if(scansProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final type = scansProvider.selectedType;

        /// El value listenable es el manejador de estado del hive pero es mas dificil capturar un loading o un error
        return ValueListenableBuilder<Box<Scan>>(
          valueListenable: context.read<HiveApi>().scansBox.listenable(), 
          builder: (_, box, __) {
            // final scans = scansProvider.scansMap[type]!;
            final scans = box.values.where((scan) => scan.tipo == type).toList();

            if(scans.isEmpty) return const _NoScans();

            return ScanList(
              type: type, 
              scans: scans, 
              onDeleteScan: (scan) async {
                // final error = await scansProvider.deleteScanById(scan.id!);
                final error = await context.read<HiveApi>().deleteScanByKey(scan.key);
                
                if(error != null) Notifications.showSnackBar(error);
              }
            );
          }
        );
      },
    );
  }  
}

class _NoScans extends StatelessWidget {
  const _NoScans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.filter_center_focus, size: 100, color: Colors.grey),
          const SizedBox(height: 10),
          Text('Scan something to start!', style: Theme.of(context).textTheme.headline5)
        ],
      ),
    );
  }
}