import 'package:flutter/material.dart';

class EventsComponent extends StatefulWidget {
  const EventsComponent({Key? key}) : super(key: key);

  @override
  State<EventsComponent> createState() => _EventsComponentState();
}

class _EventsComponentState extends State<EventsComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
      ),
      body: Container(

      ),
    );
  }
}
