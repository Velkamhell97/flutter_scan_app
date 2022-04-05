import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader_app/src/providers/providers.dart';

import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          // DeleteButton(),
          HiveDeleteButton(),

          //-Vuelve a cargar los datos en caso de error (no util con hive)
          IconButton(
            onPressed: () => context.read<ScansProvider>().loadScans(), 
            icon: Icon(Icons.replay_outlined)
          ),
        ]
      ),

      // body: ScanTiles(),
      body: HiveScanTiles(),
      
      bottomNavigationBar: CustomNavigatorBar(),
      
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}