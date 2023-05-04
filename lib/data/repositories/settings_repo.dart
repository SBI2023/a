import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:iptv_sbi_v2/presentation/resources/constants_manager.dart';

import '../../domain/models/movies_screen_model.dart';
import '../../domain/models/settings_model.dart';
import '../env/env.dart';
import '../storage/local_data.dart';

class SettingsRepository {
  SettingsModel fetchSettingsItems(){
    String? expDate, macAddress, serialNumber, modelName, code;

    macAddress = LocalData().getData("mac_address");

    if(LocalData().checkKey("exp_date") && LocalData().checkKey("is_logged_in")) {
      if(LocalData().getData("is_logged_in") == true){
        expDate = LocalData().getData("exp_date");
        serialNumber = LocalData().getData("serial_number");
        macAddress = LocalData().getData("mac_address");
        code = "UNABLE TO READ";
      }

      // LocalData().saveData("exp_date", responseAuth.expDate);
      // LocalData().saveData("code", inputCode);
      // LocalData().saveData("serial_number", serialNumber);
      // LocalData().saveData("mac_address", macAddress);
      // LocalData().saveData("is_logged_in", true);
    }

    var listMenuItems = [
      "ACCOUNT",
      "ABOUT",
      "SYSTEM SETTINGS",
      "Auto Start",
    ];

    var listMenuInformations = [
      "Expiration Date",
      "Mac Address",
      "Serial Number",
      "Version Number",
    ];

    var listOfInformations = [
      expDate??"",
      macAddress?? "2E:A0:77:07:3B:07",
      code??"",
      AppConstants.versionNumber,
    ];

    return SettingsModel(
      listMenuItems: listMenuItems,
      listMenuInformations: listMenuInformations,
      listOfInformations: listOfInformations,
      indexClicked: 0,
      backgroundImage: "${Environment.assetsPath}bg_settings_screen.jpg",
    );
  }
}
