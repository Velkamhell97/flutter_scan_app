import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../pages/pages.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;
  
  if(scan.tipo == 'http'){
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage(scan: scan)));
  }
}