import 'package:flutter/material.dart';

void openSnackbar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(
        snackMessage,
        style: const TextStyle(fontSize: 14),
      )));
}