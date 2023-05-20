import 'package:flutter/material.dart';

class ProviderContinue with ChangeNotifier {
  bool _con = true;
  bool get con => _con;

  void convert() {
    _con = !_con;
    notifyListeners();
  }

}