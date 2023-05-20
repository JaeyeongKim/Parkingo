import 'package:flutter/material.dart';

class ProviderOnce with ChangeNotifier {
  bool _once = true;
  bool get once => _once;

  void convert() {
    _once = !_once;
    notifyListeners();
  }
}