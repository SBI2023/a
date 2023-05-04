import 'package:iptv_sbi_v2/presentation/resources/constants_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../data/storage/local_data.dart';

class DeviceInfos {
  // Future<String> getMacAddress() async {
  //   // String interfaceName = await MacAddress.interfaceName;
  //   // String macAddress = await MacAddress.getMacAddress(interfaceName: interfaceName);
  //   String macAddress = await getMacAddress();
  //   print("mac adress = $macAddress");
  //   return macAddress;
  // }

  Future<String?> getIpAddress() async {
    // final response = await http.get(Uri.parse(url));
    final response =
        await http.get(Uri.parse('https://api.ipify.org/'), headers: {
      'Accept': 'application/json',
    });

    return response.statusCode == 200 ? response.body : null;
  }

  Future<PermissionStatus> requestPhonePermission() async {
    var phoneStatus = await Permission.phone.status;
    var locationStatus = await Permission.locationWhenInUse.status;

    if (!phoneStatus.isGranted) {
      await Permission.phone.request();
    }
    if (!locationStatus.isGranted) {
      await Permission.locationWhenInUse.request();
    }
    LocalData().saveData(AppConstants.phonePermissionStatus, phoneStatus);
    return phoneStatus;
  }
}
