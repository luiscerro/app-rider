import 'dart:async';
import 'dart:ui' as ui;

import 'package:app_rider/common/alert.dart';
import 'package:app_rider/common/custom_marker.dart';
import 'package:app_rider/common/location.dart';
import 'package:app_rider/common/permission.dart';
import 'package:app_rider/entities/address_place.dart';
import 'package:app_rider/entities/route_map_step.dart';
import 'package:app_rider/ui/routes/route_search_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteWFMapComponent extends StatefulWidget {
  const RouteWFMapComponent({Key? key}) : super(key: key);

  @override
  State<RouteWFMapComponent> createState() => _RouteWFMapComponentState();
}

class _RouteWFMapComponentState extends State<RouteWFMapComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = <Marker>{};
  MarkerGenerator markerGenerator = MarkerGenerator();
  List<RouteMapSteps> steps = [];
  List<Widget> items = [];
  LocationManager? _locationManager;

  final alert = Alert();
  final CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  void initState() {
    super.initState();
    _locationManager = LocationManager(context);
    _updateScreen();
    _getLocation();
  }

  _getLocation() async {
    Position? position = await _locationManager?.getCurrentPosition();
    if(position != null){
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      )));
    }
  }

  _updateScreen() {
    items = [];
    markers = <Marker>{};
    for (var step in steps) {
      var idx = steps.indexOf(step);
      var isEnd = idx == steps.length - 1 ? true: false;
      items.add(addLocationItem(step.address!, false, idx, true, isEnd));
      _addMarker(LatLng(step.lat!, step.lng!), idx, isEnd);
    }
    _setBounds();
  }

  _setBounds() async {
    List<LatLng> latLngList = [];
    final GoogleMapController controller = await _controller.future;
    for (var step in steps) {
      LatLng latLng = LatLng(step.lat!, step.lng!);
      latLngList.add(latLng);
    }
    LatLngBounds? bounds  = _locationManager?.createBounds(latLngList);
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        bounds!, 50));
  }

  void _addMarker(LatLng position, int index, bool isEnd) async {
    BitmapDescriptor iconBitmap = await markerGenerator.createBitmapDescriptorFromText(index.toString(), Colors.blue, Colors.blue, Colors.white);
    if(index > 0 && isEnd == true){
      iconBitmap = await markerGenerator.createBitmapDescriptorFromIconData(Icons.flag, Colors.blue, Colors.blue, Colors.white);
    }
    if(index == 0){
      iconBitmap = await markerGenerator.createBitmapDescriptorFromIconData(Icons.location_searching_outlined, Colors.blue, Colors.blue, Colors.white);
    }
    var markerIdVal = index.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: iconBitmap,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
      },
    );
    setState(() {
      markers.add(marker);
    });
  }

  _openSearchLocationScreen(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RouteSearchComponent()),
    );
    if(result != null) {
      Address address = result;
      RouteMapSteps step = RouteMapSteps();
      step.address = AddressFormatter.toString(address.result?.formattedAddress).street;
      step.lng = address.result?.geometry?.location?.lng;
      step.lat = address.result?.geometry?.location?.lat;
      setState(() {
        if(index == -1){
          steps.add(step);
        }else {
          steps[index] = step;
        }
        _updateScreen();

      });
    }
  }

  _deleteStep(int index) {
    print("index : $index");
    setState(() {
      steps.removeAt(index);
      _updateScreen();
    });
  }


  addLocationItem(String label, bool? isEmpty, int index, bool isDelete, bool isEnd) {
    Widget leftIcon = Container();
    var textStyle = const TextStyle();
    if(isEmpty == true){
      textStyle = const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic);
    }
    if(index == -1){
      leftIcon = const Icon(Icons.add_box_outlined);
    }
    if(index == 0){
      leftIcon = const Icon(Icons.location_searching_outlined);
    }
    if(index > 0){
      leftIcon = Container(
        alignment: Alignment.center,
        width: 25,
        height: 25,
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.3,
                color: Colors.grey
            ),
            borderRadius: const BorderRadius.all(Radius.circular(13))
        ),
        child: Text(index.toString()),);
    }
    if(isEnd){
      leftIcon = Container(
        alignment: Alignment.center,
        width: 25,
        height: 25,
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.3,
                color: Colors.grey
            ),
            borderRadius: const BorderRadius.all(Radius.circular(13))
        ),
        child: const Icon(Icons.flag, size: 16,),);
    }
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () => {
              _openSearchLocationScreen(index)
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  leftIcon,
                  const SizedBox(width: 10,),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                                color: Colors.grey
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        child: Text(label, style: textStyle,),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
        
        Visibility(
          visible: isDelete ? true : false,
          child: Flexible(
              flex: 0,
              child: GestureDetector(
                onTap: () {
                  _deleteStep(index);
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 10),
                  width: 40,
                    child: const Icon(Icons.delete_outline, size: 22)
                ),
              )
          ),
        ),

        Visibility(
            visible: isDelete ? false : true,
            child: const SizedBox(width: 40,))
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planificar Ruta"),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const RouteWFMapComponent(),
              //   ),
              // );
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 0,
            child:  ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250.0,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      ...items,
                      addLocationItem(steps.isEmpty ? "Punto de partida": "Agregar parada" , true, -1, false, false)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child:GoogleMap(
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: markers,
              initialCameraPosition: _initialCamera,

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          )
        ],
      ),
    );
  }



}