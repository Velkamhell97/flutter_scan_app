import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';

class ScanList extends StatefulWidget {
  final String type;
  final List<Scan> scans;
  final Function(Scan scan) onDeleteScan;

  const ScanList({
    Key? key, 
    required this.type, 
    required this.scans, 
    required this.onDeleteScan,
  }) : super(key: key);

  @override
  State<ScanList> createState() => _ScanListState();
}

class _ScanListState extends State<ScanList> {
  final _dismissNotifier = ValueNotifier<double>(0.0);

  static const Map<String, IconData> _scansIcons = {
    'geo' : Icons.map_outlined,
    'http'  : Icons.compass_calibration,
  };

  @override
  Widget build(BuildContext context) {
    final tileWidth = MediaQuery.of(context).size.width;
    print(widget.type);

    return ListView.builder(
      // reverse: true,
      physics: const BouncingScrollPhysics(),
      controller: context.read<UIProvider>().scrollController,
      /// Para almacenar la posicion del scroll de cada lista
      key: PageStorageKey(widget.type),
      itemCount: widget.scans.length,
      itemBuilder: (_, index) { 
        final scan = widget.scans[index];
  
        return Listener(
          onPointerMove: (event) {
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
            onDismissed: (_) => widget.onDeleteScan(scan),
            child: ListTile(
              leading: Icon(_scansIcons[widget.type]),
              trailing: const Icon(Icons.keyboard_arrow_right),
              title: Text(scan.valor),
              subtitle: Text('${scan.tipo}: ${scan.key}'),
              onTap: () async {
                if(scan.tipo == 'http'){
                  await canLaunch(scan.valor) ? await launch(scan.valor) : throw 'Could not launch ${scan.valor}';
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage(scan: scan)));
                }
              },
            ),
          ),
        );
      },
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
          children: const [
            Icon(Icons.arrow_back, color: Colors.white),
            SizedBox(width: 10),
            Text('Swipe to delete', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}