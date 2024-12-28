import 'package:flutter/material.dart';

extension ShowSnackbar on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 148),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 6.2,
        horizontal: 12.0,
      ),
      backgroundColor: backgroundColor ?? Colors.grey.shade800,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(
        message: message, backgroundColor: Theme.of(this).colorScheme.error);
  }
}
