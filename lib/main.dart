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

  await Hive.initFlutter();
  Hive.registerAdapter(HiveScanModelAdapter()); //-Crea el adapter
  await Hive.openBox<HiveScanModel>('scans'); //-Abre el box, crea la tabla o si exsite la abre

  final sqflite = SqfliteApi();
  await sqflite.initDB();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider(create: (_) => HiveApi()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ScansProvider()),
        ChangeNotifierProvider(create: (_) => HiveScansProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Notifications.messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {
          'home' : (_) => HomePage(),
          // 'map' : (_) => MapPage()
        },
        theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.deepPurple,
            onSecondary: Colors.white,
          ),
          listTileTheme: ListTileThemeData(
            iconColor: Colors.deepPurple
          ),
          iconTheme: IconThemeData(
            color: Colors.deepPurple
          )
        ),
      ),
    );
  }
}