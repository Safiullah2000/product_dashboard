import 'package:flutter/services.dart' show rootBundle;

class LocalDataProvider {
  Future<String> loadJsonAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}
