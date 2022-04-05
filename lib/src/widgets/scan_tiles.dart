import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';
import '../services/services.dart';

//-Similar al scan hive tiles, salvo que aqui si podemos controlar que se renderize solo los scans activos
//-al agregar uno nuevo
class ScanTiles extends StatefulWidget {
  const ScanTiles({Key? key}) : super(key: key);

  @override
  State<ScanTiles> createState() => _ScanTilesState();
}

class _ScanTilesState extends State<ScanTiles> {
  final _dismissNotifier = ValueNotifier<double>(0.0);

  static const Map<String, IconData> _scansIcons = {
    'geo'  : Icons.compass_calibration,
    'http' : Icons.map_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scansProvider =  context.watch<ScansProvider>();
    // print('tiles build');

    if(scansProvider.error != null) {
      return Center(child: Text(scansProvider.error!));
    }

    if(scansProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selected = scansProvider.selectedType;

    final icon = _scansIcons[selected]!;
    final scans = scansProvider.scansMap[selected]!;

    final tileWidth = MediaQuery.of(context).size.width;

    if(scans.length == 0) return _NoScans();
    
    return ListView.builder(
      // reverse: true,
      physics: BouncingScrollPhysics(),
      controller: scansProvider.scrollController,
      key: PageStorageKey(selected),
      itemCount: scans.length,
      itemBuilder: (_, index) { 
        final scan = scans[index];

        return Listener(
          onPointerMove: (event) {
            final percent = event.position.dx / tileWidth;
            _dismissNotifier.value = percent;
          },
          child: Dismissible(
            key: ValueKey(scan.id.toString()),
            direction: DismissDirection.endToStart,
            background: ValueListenableBuilder<double>(
              valueListenable: _dismissNotifier,
              builder: (_, value, __) {
                final offset = 50.0 * (1 - value);
                return _DismissBackground(offset: offset);
              },
            ),
            onDismissed: (_) async {
              final error = await context.read<ScansProvider>().deleteScanById(scan.id!);

              if(error != null){
                Notifications.showSnackBar(error);
              }
            },
            child: ListTile(
              leading: Icon(icon),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(scan.valor),
              subtitle: Text('${scan.id}'),
              onTap: () => launchURL(context, scan),
            ),
          ),
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