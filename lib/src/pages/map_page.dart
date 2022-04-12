import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/models.dart';

class MapPage extends StatefulWidget {
  final Scan scan;

  const MapPage({Key? key, required this.scan}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final GoogleMapController _mapController;
  late final CameraPosition initialPosition;
  
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    
    initialPosition = CameraPosition(
      target: widget.scan.getLatLng(),
      zoom: 17.5,
      tilt: 50
    );

    markers.add(Marker(
      markerId: const MarkerId('geo-location'),
      position: widget.scan.getLatLng()
    ));
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  MapType mapType = MapType.normal;

  void backToCenter() async {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(initialPosition.target)
    );
  }

  void switchMapType() {
    if(mapType == MapType.normal){
      mapType = MapType.satellite;
    } else {
      mapType = MapType.normal;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () => backToCenter(), 
            icon: const Icon(Icons.location_on)
          )
        ],
      ),

      body: GoogleMap(
        mapType: mapType,
        markers: markers,
        initialCameraPosition: initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        zoomControlsEnabled: false,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => switchMapType(),
        child: const Icon(Icons.layers),
      ),
    );
  }
}