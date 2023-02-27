import 'package:flutter/material.dart';

class Alert {

  void message(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Cerrar', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void error(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text("Se produjo un error. vuelve a intentarlo"),
        action: SnackBarAction(label: 'Cerrar', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}