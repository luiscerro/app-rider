import 'package:app_rider/entities/address_place.dart';
import 'package:app_rider/service/address_service.dart';
import 'package:app_rider/ui/routes/router_map_select_location.dart';
import 'package:flutter/material.dart';

class RouteSearchComponent extends StatefulWidget {
  const RouteSearchComponent({Key? key}) : super(key: key);

  @override
  State<RouteSearchComponent> createState() => _RouteSearchComponentState();
}

class _RouteSearchComponentState extends State<RouteSearchComponent> {
  final inputController = TextEditingController();
  final _addressService = AddressService();
  List<Prediction> predictions = [];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSearchField() {
    return Container(
      height: 35,
      padding: const EdgeInsets.only(left: 10, top: 5),
      decoration: BoxDecoration(

          border: Border.all(
              width: 0.3,
            color: Colors.grey,
            style: BorderStyle.solid
          ),
          borderRadius: const BorderRadius.all(Radius.circular(18))
      ),
      child: TextField(
        controller: inputController,
        onChanged: (value) => {_searchAddress(value)},
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Buscar dirección",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(11),
        ),
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }

  _searchAddress(String text) async {
    AddressPlace addressPlace = await _addressService.searchAddress(text);
    setState(() {
      predictions = addressPlace.predictions!;
    });
  }

  _onSelect(Prediction p) async {
    Address address = await _addressService.getAddressByPlaceId(p.placeId!);
    Navigator.pop(context, address);
  }


  _buildItem(Prediction prediction) {
    AddressFormatter addressFormatter = AddressFormatter.toString(prediction.description!);
    return ListTile(
      leading: const Icon(Icons.location_on_outlined),
      minLeadingWidth: 30,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      title: Text(addressFormatter.street!),
      subtitle: Text(addressFormatter.location!),
      onTap: () => {
        _onSelect(prediction)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
      ),
      body:predictions.isNotEmpty ? ListView.separated(
          itemCount: predictions.length,
          itemBuilder: (context , i) {
            final prediction = predictions[i];
            return _buildItem(prediction);
          },
          separatorBuilder: (context, i) {
            return const Divider(endIndent: 10, indent: 55);
          },
      ):GestureDetector(
        onTap: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RouterMapSelectLocation(),
            ),
          )
        },
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          child: Row(
            children: const [
              Icon(Icons.location_on_outlined),
              SizedBox(width: 20,),
              Text("Elegir en el mapa")
            ],
          ),
        ),
      ),
    );
  }
}
