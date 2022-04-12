import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/pages.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  static const _errorText = 'There was an error while saving the scan in db please try again';
  // static const _scrollDuration = Duration(milliseconds: 300);

  /// http://fernando-herrera.com', geo:2.9284365,-75.2828932, barcodeScanRes
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#673AB7', 'Cancelar', false, ScanMode.QR);
        
        if(barcodeScanRes == '-1') return Notifications.showSnackBar('Scan canceled');

        final scansProvider = context.read<ScansProvider>();

        // final newScan = await scansProvider.newScan(barcodeScanRes);
        final newScan = await context.read<HiveApi>().insertScan(barcodeScanRes);

        if (newScan == null) return Notifications.showSnackBar(_errorText);

        if (newScan.tipo != scansProvider.selectedType) {
          scansProvider.selectedType = newScan.tipo;
          context.read<UIProvider>().currentIndex = scansProvider.getIndex(newScan.tipo);
        }

        /// Para llevar el scroll a la ultima posicion
        // Future.delayed(_scrollDuration, () {
        //   final scroll = context.read<UIProvider>().scrollController;
        //   scroll.animateTo(scroll.position.maxScrollExtent, duration: _scrollDuration, curve: Curves.linear);
        // });

        if(newScan.tipo == 'http'){
          await canLaunch(newScan.valor) ? await launch(newScan.valor) : throw 'Could not launch ${newScan.valor}';
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage(scan: newScan)));
        }
      },
      child: const Icon(Icons.filter_center_focus),
      elevation: 0,
    );
  }
}
