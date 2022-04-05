import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  Future<HiveScanModel?> scanForHive (BuildContext context) async {
    final hive = context.read<HiveApi>();

    // final scan = await hive.insertScan('http://fernando-herrera.com');
    final scan = await hive.insertScan('geo:2.9284365,-75.2828932');

    return scan!;
  }

  Future<ScanModel?> addScanFalse (BuildContext context) async{
    final scansProvider = context.read<ScansProvider>();

    final scan = await scansProvider.newScan('http://fernando-herrera.com');
    // final scan = await scansProvider.newScan('geo:43,-34');

    return scan!;
  }

  // static const _scrollDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#673AB7', 'Cancelar', false, ScanMode.QR);
        //
        // if(barcodeScanRes == '-1'){
        //   return;
        // } 
        //
        // final newScan = await scanListProvider.newScan(barcodeScanRes);
        //
        // if(newScan == null) {
        //   Notifications.showSnackBar('Scan canceled');
        // }

        final newScan = await scanForHive(context);
        // await addScanFalse(context);

        if(newScan == null){
          Notifications.showSnackBar('There was an error while saving the scan in db please try again');
          return;
        }

        // final scansProvider = context.read<ScansProvider>();
        final scansProvider = context.read<HiveScansProvider>();

        if(newScan.tipo != scansProvider.selectedType){
          final navigationProvider = context.read<NavigationProvider>();

          navigationProvider.currentIndex = scansProvider.getIndex(newScan.tipo);
          scansProvider.selectedType = newScan.tipo;
        }

        //-Para llevar el scroll a la ultima posicion
        // Future.delayed(_scrollDuration, () {
        //   final maxExtent = scansProvider.scrollController.position.maxScrollExtent;
        //   scansProvider.scrollController.animateTo(maxExtent, duration: _scrollDuration, curve: Curves.linear);
        // });

        launchURL(context, ScanModel(tipo: newScan.tipo, valor: newScan.valor));
      },
      child: Icon(Icons.filter_center_focus),
      elevation: 0,
    );
  }
}