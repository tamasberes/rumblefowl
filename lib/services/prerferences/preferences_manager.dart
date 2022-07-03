
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('PreferencesManager');

class PreferencesManager with ChangeNotifier {
  late SharedPreferences prefs;

  PreferencesManager._privateConstructor();

  static final PreferencesManager _instance = PreferencesManager._privateConstructor();

  factory PreferencesManager() {
    return _instance;
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static const String keySelectedMailbox = "keySelectedMailbox";
  static const String keySelectedfolder = "keySelectedfolder";

  int getSelectedMailbox() {
    return (prefs.getInt(keySelectedMailbox) ?? 0);
  }

  setSelectedMailbox(int index) {
    log.info("setSelectedMailbox: $index");
    prefs.setInt(keySelectedMailbox, index);
    notifyListeners();
  }

  String getSelectedFolder() {
    return (prefs.getString(keySelectedfolder) ?? "inbox");
  }

  setSelectedFolder(String folderName) {
    log.info("keySelectedfolder: $folderName");
    prefs.setString(keySelectedfolder, folderName);
    notifyListeners();
  }

}
