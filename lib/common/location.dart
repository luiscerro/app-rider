
import 'dart:async';

import 'package:app_rider/common/permission.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationManager {

  Permission? _permission;

  LocationManager(BuildContext context){
    _permission = Permission(context);
  }

  FutureOr<Position?> getCurrentPosition() async {
    if(_permission != null) {
      bool? hasPermission = await _permission?.handleLocationPermission();
      if (hasPermission == null || !hasPermission) return null;
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        return position;
      }).catchError((e) {
        debugPrint(e);
      });
    }else {
      return null;
    }
  }

  LatLngBounds createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon)
    );
  }
}