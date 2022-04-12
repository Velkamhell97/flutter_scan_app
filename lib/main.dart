import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/models/models.dart';
import 'src/pages/pages.dart';
import 'src/providers/providers.dart';
import 'src/services/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  /// Inicializa los servicios de hive, registra los adapters para la api y abra las box 
  await Hive.initFlutter();
  Hive.registerAdapter(ScanAdapter()); 
  await Hive.openBox<Scan>('scans');

  /// Todas las clases que necesiten inicializacion en el punto mas alto de la app, deben ser
  /// clases singlenton o estaticas para poder ser utilizadas en este punto, en este caso como
  /// el sqflite api va a actuar mas como tipo de provider (solo se usara dentro de este) se 
  /// declara singlenton pero por ejemplo un servicio de notificaciones seria mejor estatico
  await SqfliteApi().initDB();

  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => HiveApi()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => ScansProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Notifications.messengerKey,
        navigatorKey: Notifications.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        home: const HomePage(),
        theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.deepPurple,
            onSecondary: Colors.white,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.deepPurple
          ),
          iconTheme: const IconThemeData(
            color: Colors.deepPurple
          )
        ),
      ),
    );
  }
}