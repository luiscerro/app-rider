import 'package:flutter/material.dart';


class HomeComponent extends StatefulWidget {
  const HomeComponent({Key? key}) : super(key: key);
  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
      ),
      body: const Center(

      ),
    );
  }
}
