import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../providers/providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Historial'),
        actions: [
          const DeleteButton(),
          IconButton(
            onPressed: () => context.read<ScansProvider>().loadScans(), 
            icon: const Icon(Icons.replay_outlined)
          ),
        ]
      ),

      body: const ScanTiles(),
      
      bottomNavigationBar: const CustomNavigatorBar(),
      
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}