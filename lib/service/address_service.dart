
import 'package:app_rider/config.dart';
import 'package:app_rider/entities/address_place.dart';
import 'package:dio/dio.dart';

class AddressService {

  final _dio = Dio();

  Future searchAddress(String name) async {
    dynamic data;
    try {
      final url ="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$name&key=${Config().GOOGLE_API_KEY}&sessiontoken=${Config().GOOGLE_SESSION_TOKEN}&components=country:cl";
      final resp = await _dio.get(url);
      data = resp.data;
      return AddressPlace.fromJson(data);
    }catch(e){
      throw e;
    }
  }


  Future getAddressByPlaceId(String placeId) async {
    dynamic data;
    try {
      final url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Config().GOOGLE_API_KEY}";
      final resp = await _dio.get(url);
      data = resp.data;
      return Address.fromJson(data);
    }catch(e){
      throw e;
    }
  }

}