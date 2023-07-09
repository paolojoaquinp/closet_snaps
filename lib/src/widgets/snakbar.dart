import 'package:flutter/material.dart';

void mostrarSnackbar(BuildContext context, String mensaje) {
  final snackbar = SnackBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    content: Text(
      mensaje,
      style: ThemeData.light().textTheme.bodyMedium,
    ),
    duration: Duration(milliseconds: 1500),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}