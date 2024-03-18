import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileProvider with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();

  String _themeMode = 'system';
  String get themeMode => _themeMode;

  void setThemeMode(String value) {
    _themeMode = value;
    _secureStorage.write(key: 'themeMode', value: value);
    notifyListeners();
  }

  void getThemeMode() async {
    final themeMode = await _secureStorage.read(key: 'themeMode');
    if (themeMode != null) {
      _themeMode = themeMode;
      notifyListeners();
    }
  }

  String _languageCode = 'en';
  String get languageCode => _languageCode;

  void setLanguageCode(String value) {
    _languageCode = value;
    _secureStorage.write(key: 'languageCode', value: value);
    notifyListeners();
  }

  void getLanguageCode() async {
    final languageCode = await _secureStorage.read(key: 'languageCode');
    if (languageCode != null) {
      _languageCode = languageCode;
      notifyListeners();
    }
  }
}
