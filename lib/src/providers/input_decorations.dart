import 'package:flutter/material.dart';
import 'package:rrhh/src/tema/primary.dart';

class InputDecorations {

  static InputDecoration loginInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Primary.azul
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Primary.azul,
          width: 2
        )
      ),
      //hintText: hintText,
      /*
      labelText: labelText,
      labelStyle: TextStyle(
        color: Primary.azul,
        fontWeight: FontWeight.bold,
        fontSize: 16
      ),
      */
      prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: Primary.azul)
        : null
    );
  }

  static InputDecoration loginInputDecoration2({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Primary.azul
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Primary.azul,
          width: 2
        )
      ),
      //hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(
        color: Primary.azul,
        fontWeight: FontWeight.w700,
        fontSize: 12
      ),
      prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: Primary.azul)
        : null
    );
  }
}