import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';


  Future<Color> getColorPalette(String? fotoUrl, PickedFile? foto) async {
    Color colorFinal = Colors.grey;
    if (fotoUrl != null) {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
              NetworkImage(fotoUrl));
      colorFinal = paletteGenerator.dominantColor!.color;
    } else if (foto != null) {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(FileImage(File(foto.path)));
      colorFinal = paletteGenerator.dominantColor!.color;
    }
    return colorFinal;
  }

  Color parseColorfromString(String hexColor) {
    return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
  }

  String obtenerDateFormated(DateTime date) {
    final fechaFormateada = DateFormat('EEEE \ndd', 'es').format(date);
    return fechaFormateada;
  }
  String obtenerDateFormatedInline(DateTime date) {
    final fechaFormateada = DateFormat('EEEE dd', 'es').format(date);
    return fechaFormateada;
  }

  String obtenerFirstWord(String texto) {
    final palabras = texto.trim().split(' ');
    for (final palabra in palabras) {
      if (palabra.length <= 15) {
        return palabra;
      } else {
        return 'Tu nombre es bastante largo :(';
      }
    }
    return '';
  }

  String getFirstCharacterUpperCase(String text) {
  if (text.isNotEmpty) {
    return text.substring(0, 1).toUpperCase();
  }
  return '';
}