import 'package:get/get_core/get_core.dart';
import 'package:get_storage/get_storage.dart';

class LocalData {
  // Save data
  void saveData(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  // Retrieve data
  dynamic getData(String key) {
    return GetStorage().read(key);
  }

  // Check if key already exist or not
  bool checkKey(String key) {
    return GetStorage().hasData(key);
  }

  // Delete a value with a key
  void destroyData(String key) {
    GetStorage().remove(key);
  }

  // Clear all data in the box
  void eraseAllData() {
    GetStorage().erase();
  }
}
