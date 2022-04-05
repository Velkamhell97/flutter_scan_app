import 'package:flutter/material.dart';

class ScanCategory {
  final String type;
  final IconData icon;
  final String label;

  const ScanCategory({required this.type, required this.icon, required this.label});

  static const categories = [
    ScanCategory(
      type: "geo", 
      icon: Icons.map_outlined, 
      label: "Mapa"
    ),
    ScanCategory(
      type: "http", 
      icon: Icons.compass_calibration, 
      label: "Direcciones"
    )
  ];
}