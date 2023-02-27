import 'dart:async';
import 'dart:math';

import 'package:app_rider/ui/routes/route_wf_map_component.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RouteWFInfoComponent extends StatefulWidget {
  const RouteWFInfoComponent({Key? key}) : super(key: key);

  @override
  State<RouteWFInfoComponent> createState() => _RouteWFInfoComponentState();
}

class _RouteWFInfoComponentState extends State<RouteWFInfoComponent> {
  TextEditingController txTitle = TextEditingController();
  TextEditingController txDate = TextEditingController();
  TextEditingController txHour = TextEditingController();
  final dateFormat = DateFormat("dd/MM/yyyy");

  Future<void> _selectDate() async {
    DateTime selectedDate;

    selectedDate = DateTime.now();

    print("show picker");
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      txDate.text = dateFormat.format(picked.toUtc());
    }
  }

  Future<void> _selectHour() async {
    final TimeOfDay? hour = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 47),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if(hour != null){
      txHour.text = "${hour.hour}:${hour.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Planificar Ruta"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RouteWFMapComponent(),
                  ),
                );
              },
              child: Text('Continuar'),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: txTitle,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Titulo',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txDate,
                onTap: () => {_selectDate()},
                readOnly: true,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Fecha',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txHour,
                onTap: () => {_selectHour()},
                readOnly: true,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Hora',
                ),
              )
            ],
          ),
        ));
  }
}
