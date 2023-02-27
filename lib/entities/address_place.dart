class Prediction {
  String? description;
  String? placeId;
  Prediction({this.description, this.placeId});
  factory Prediction.fromJson(Map<String, dynamic> json) =>
      Prediction(
        description: json['description'],
        placeId: json['place_id'],
      );
}


class AddressPlace {
  List<Prediction>? predictions;
  AddressPlace({this.predictions});
  factory AddressPlace.fromJson(Map<String, dynamic> json)
  {
    List<Prediction> addressPlaceFromJson(List<dynamic> jsonData) {
      return List<Prediction>.from(jsonData.map((item) => Prediction.fromJson(item)));
    }
    return AddressPlace(
        predictions: addressPlaceFromJson(json['predictions'])
    );
  }
}

class Address  {
  Result? result;
  Address({this.result});
  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(
          result: Result.fromJson(json['result'])
      );
}

class Result  {
  String? formattedAddress;
  List<AddressComponents>?  addressComponents;
  Geometry? geometry;
  Result({this.addressComponents, this.geometry, this.formattedAddress});
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        formattedAddress: json['formatted_address'],
        addressComponents: List<AddressComponents>.from(json['address_components'].map((item) => AddressComponents.fromJson(item))),
        geometry: Geometry.fromJson(json['geometry'])
    );
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;
  AddressComponents({this.longName, this.shortName, this.types});
  factory AddressComponents.fromJson(Map<String, dynamic> json) =>
      AddressComponents(
          longName: json['long_name'],
          shortName: json['short_name'],
          types: List<String>.from(json['types'].map((item) => item))
      );
}

class Geometry {
  Location? location;
  Geometry({this.location});
  factory Geometry.fromJson(Map<String, dynamic> json) =>
      Geometry(
        location: Location.fromJson(json['location']),
      );
}

class Location {
  double? lat;
  double? lng;
  Location({this.lat, this.lng});
  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(
        lat: json['lat'],
        lng: json['lng'],
      );
}


class AddressFormatter  {
  String? street;
  String? location;
  AddressFormatter({this.street, this.location});
  factory AddressFormatter.toString(String? address) {
    int idx = address!.indexOf(",");
    return  AddressFormatter(
        street: address.substring(0, idx).trim(),
        location: address.substring(idx + 1).trim()
    );
  }
}