import 'dart:async';

import 'package:app_rider/common/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterMapSelectLocation extends StatefulWidget {
  const RouterMapSelectLocation({Key? key}) : super(key: key);

  @override
  State<RouterMapSelectLocation> createState() => _RouterMapSelectLocationState();
}

class _RouterMapSelectLocationState extends State<RouterMapSelectLocation> {
  LocationManager? _locationManager;
  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _locationManager = LocationManager(context);
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position? position = await _locationManager?.getCurrentPosition();
    if(position != null){
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12,
      )));
    }
  }

  _selectLocation() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
    );

    print("latitude : ${centerLatLng.latitude}");
    print("longitude : ${centerLatLng.longitude}");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar destino"),
        actions: [
          TextButton(
            onPressed: () {
              _selectLocation();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _initialCamera,

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          const Icon(Icons.location_searching_outlined)
        ],
      ),
    );
  }
}
