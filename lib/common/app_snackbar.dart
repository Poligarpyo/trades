import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'navigation_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'navigation_keys.dart';

class AppSnackbar {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
