import 'package:app_rider/common/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Permission {
  final _alert = Alert();
  BuildContext? _context;
  Permission(BuildContext context){
    _context = context;
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _alert.message(_context!, 'Los servicios de ubicación están deshabilitados. Habilite los servicios');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _alert.message(_context!, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _alert.message(_context!, 'Los permisos de ubicación se han negado permanentemente, no podemos solicitar permisos.');
      return false;
    }
    return true;
  }
}