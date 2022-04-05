import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../utils/utils.dart';

class HiveScanTiles extends StatefulWidget {
  const HiveScanTiles({Key? key}) : super(key: key);

  @override
  State<HiveScanTiles> createState() => _HiveScanTilesState();
}

class _HiveScanTilesState extends State<HiveScanTiles> {
  final _dismissNotifier = ValueNotifier(0.0); //Para el dismissable

  //-Caso particular que cada lista tega su icono
  static const Map<String, IconData> _scansIcons = {
    'geo'  : Icons.compass_calibration,
    'http' : Icons.map_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scansProvider = context.watch<HiveScansProvider>();

    if(scansProvider.error != null) {
      return Center(child: Text(scansProvider.error!));
    }

    if(scansProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final type = scansProvider.selectedType;
    final icon = _scansIcons[type]!;

    final tileWidth = MediaQuery.of(context).size.width;
    // print('tiles build');

    //-La diferencia con hive esque este si escucha y redibuja cuando hay cambios en cualquier categoria
    //-El manejo de error de la primera carga es mas complicado (y muy improbable)
    return ValueListenableBuilder<Box<HiveScanModel>>(
      valueListenable: context.read<HiveApi>().scansBox.listenable(), 
      builder: (context, box, _){
        final scans = box.values.where((scan) => scan.tipo == type).toList();

        if(scans.length == 0) return _NoScans();
    
        return ListView.builder(
          // reverse: true,
          physics: BouncingScrollPhysics(),
          controller: scansProvider.scrollController,
          //-Para almacenar diferentes puntos de scroll para los diferentes tipos
          key: PageStorageKey(type),
          itemCount: scans.length,
          itemBuilder: (_, index) { 
            final scan = scans[index];

            return Listener(
              onPointerMove: (event) {
                //-Porcentaje del dismiss desplazado
                final percent = event.position.dx / tileWidth;
                _dismissNotifier.value = percent;
              },
              child: Dismissible(
                key: ValueKey(scan.key.toString()),
                direction: DismissDirection.endToStart,
                background: ValueListenableBuilder<double>(
                  valueListenable: _dismissNotifier,
                  builder: (_, value, __) {
                    final offset = 50.0 * (1 - value);
                    return _DismissBackground(offset: offset);
                  },
                ),
                onDismissed: (_) async {
                  final error = await context.read<HiveApi>().deleteScanByKey(scan.key);

                  if(error != null){
                    Notifications.showSnackBar(error);
                  }
                },
                child: ListTile(
                  leading: Icon(icon),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(scan.valor),
                  subtitle: Text('${scan.key}'),
                  onTap: () => launchURL(context, ScanModel(tipo: scan.tipo, valor: scan.valor)),
                ),
              ),
            );
          },
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
          Icon(Icons.filter_center_focus, size: 100, color: Colors.grey),
          SizedBox(height: 10),
          Text('Scan something to start!', style: Theme.of(context).textTheme.headline5)
        ],
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  final double offset;

  const _DismissBackground({Key? key, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final tileWidth = MediaQuery.of(context).size.width;
    // final offset = lerpDouble(tileWidth / 2, 0, value)!;
    
    return Container(
      color: Colors.redAccent,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10.0),
      child: Transform.translate(
        offset: Offset(-offset, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.arrow_back, color: Colors.white),
            const SizedBox(width: 10),
            Text('Swipe to delete', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}


