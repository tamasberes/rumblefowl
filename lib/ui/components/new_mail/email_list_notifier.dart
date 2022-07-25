import 'package:flutter/material.dart';

class EmailListNotifier extends ChangeNotifier {
  List<String> emails = [];

  List<String> get() {
    return emails;
  }

  removeAt(int index) {
    emails.removeAt(index);
    notifyListeners();
  }

  add(String email) {
    emails.add(email);
    notifyListeners();
  }
}
