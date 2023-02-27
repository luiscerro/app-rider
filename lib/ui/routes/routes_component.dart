import 'package:app_rider/ui/routes/route_wf_info_component.dart';
import 'package:flutter/material.dart';

class RoutesComponent extends StatefulWidget {
  const RoutesComponent({Key? key}) : super(key: key);

  @override
  State<RoutesComponent> createState() => _RoutesComponentState();
}

class _RoutesComponentState extends State<RoutesComponent> {
  itemOptionAdd(String label) {
    return Container(
        padding:
            const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ));
  }

  openOptionAdd() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        "Opciones",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.close)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: itemOptionAdd("Grabar Ruta"),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RouteWFInfoComponent(),
                    ),
                  )
                },
                child: itemOptionAdd("Planificar Ruta"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Add Route',
            onPressed: () {
              openOptionAdd();
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
