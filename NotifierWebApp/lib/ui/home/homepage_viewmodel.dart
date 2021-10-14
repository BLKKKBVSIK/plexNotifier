import 'dart:html';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  String _testText = "DefaultText";
  String get testText => _testText;

  TextEditingController _textfieldController = TextEditingController();
  TextEditingController get textfieldController => _textfieldController;

  initialise() async {
    _textfieldController =
        TextEditingController(text: await readLocalDatabase('storedData'));
  }

  void setText(String newValue) {
    _testText = newValue;
    notifyListeners();
  }

  //Todo: Implement Database access

  Future<String> readLocalDatabase(String entry) async {
    return "";
  }

  Future<String> readFile(String path) async {
    var request = await HttpRequest.request(path);
    var response = request.response;

    return response;
  }

  void saveData() async {}
}
