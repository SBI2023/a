import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/app/device_info.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_information/device_information.dart';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:client_information/client_information.dart';
import '../../../../../data/env/env.dart';
import '../../../../../data/storage/local_data.dart';
import '../../../../../domain/response/auth_response.dart';
import '../../../../../domain/services/auth_services.dart';
import '../../../../data/storage/secure_storage.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';

abstract class LoginViewModelInputs {
  void login(String inputCode);
}

abstract class LoginViewModelOutputs {
  Stream<bool> get isLoadingStream;

  Stream<String> get errorStream;

  Stream<bool> get loginSuccessStream;
}

// 225175214208
// 267455020925
class LoginViewModel implements LoginViewModelInputs, LoginViewModelOutputs {
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _errorSubject = BehaviorSubject<String>();
  final _loginSuccessSubject = BehaviorSubject<bool>.seeded(false);
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  String? macAddress, serialNumber, modelName;

  @override
  Future<bool> login(String inputCode) async {
    _isLoadingSubject.add(true);
    _loginSuccessSubject.add(false);
    LocalData().saveData("is_logged_in", false);

    //print("from login heeyyy: $macAddress, $modelName, $serialNumber");
    //print(
    //  "url auth : ${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=$macAddress&sn=$serialNumber&model=$modelName");

    try {
      final response = await http.post(Uri.parse(
              //'${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=$macAddress&sn=$serialNumber&model=$modelName'),
              '${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=null&sn=null&model=null'),
          headers: {
            'Accept': 'application/json',
          });

      String decryptedData = Environment.encryptDecrypt(response.body);

      print("decryptedData = ${decryptedData.toString()}");

      ResponseAuth responseAuth =
          ResponseAuth.fromJson(jsonDecode(decryptedData));

      print("responseAuth.status = ${responseAuth.status}");

      if (responseAuth.status.toString() == "1") {
        _loginSuccessSubject.add(true);
        LocalData().saveData("exp_date", responseAuth.expDate);
        LocalData().saveData("code", inputCode);
        // LocalData().saveData("code", "255473128661");
        LocalData().saveData("serial_number", serialNumber);
        LocalData().saveData("mac_address", macAddress);
        LocalData().saveData("is_logged_in", true);

        print("_loginSuccessSubject : ${_loginSuccessSubject.value}");
      } else {
        _errorSubject.add('Failed to login');
      }
    } catch (e) {
      _errorSubject.add('Error occurred: $e');
    } finally {
      print("_loginSuccessSubject finally: ${_loginSuccessSubject.value}");

      _isLoadingSubject.add(false);
    }
    return _loginSuccessSubject.value;
  }

  void dispose() {
    _isLoadingSubject.close();
    _errorSubject.close();
    _loginSuccessSubject.close();
  }

  void start() {
    getMacAddress();
    //getModelName();
  }

  void getMacAddress() async {
    try {
      //macAddress = await _networkInfo.getWifiBSSID();
      print("wifiBSSID = $macAddress");
    } on PlatformException catch (e) {
      macAddress = 'Failed to get Wifi BSSID';
    }
  }

  /*void getModelName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        print("devise is Android = ${Platform.isAndroid}");
        print("devise is IOS = ${Platform.isIOS}");
        final androidInfo = await deviceInfo.androidInfo;
        print("android info : ${androidInfo.toString()}");
        modelName = androidInfo.model;

        macAddress = androidInfo.id;
        if (androidInfo.serialNumber != "unknown") {
          serialNumber = androidInfo.serialNumber;
          print("serial number is serialNumber = $serialNumber");
        } else {
          serialNumber = androidInfo.display;
        }
        print("id view model = ${macAddress.toString()}");
        print("model name view model = $modelName");
      } else if (Platform.isIOS) {
        print("devise is Android = ${Platform.isAndroid}");
        print("devise is IOS = ${Platform.isIOS}");
        final iosInfo = await deviceInfo.iosInfo;
        modelName = iosInfo.utsname.machine;
        print("model name = $modelName");
      }
    } catch (e) {
      print("error of getModelName : ${e.toString()}");
    }
    // await Future.delayed(Duration(seconds: 1)); // Example delay

    // return modelName!;
    // return 'Example Model';
  }
*/
  @override
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  Stream<String> get errorStream => _errorSubject.stream;

  @override
  Stream<bool> get loginSuccessStream => _loginSuccessSubject.stream;
}

/*
class LoginViewModel implements LoginViewModelInputs, LoginViewModelOutputs {
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _errorSubject = BehaviorSubject<String>();
  final _loginSuccessSubject = BehaviorSubject<bool>.seeded(false);
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  String? macAddress,
      serialNumber,
      modelName,
      ipv4Address,
      ipv6Address,
      imeiNumber;

  @override
  Future<bool> login(String inputCode) async {
    _isLoadingSubject.add(true);
    _loginSuccessSubject.add(false);
    PermissionStatus status =
        localData.getData(AppConstants.phonePermissionStatus);

    print(
        "from login heeyyy: $macAddress, $modelName, $serialNumber , $ipv4Address, $ipv6Address ");
    print(
        "url auth : ${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=${ipv6Address??imeiNumber??macAddress}&sn=$serialNumber&model=$modelName");

    try {
      if (status.isGranted) {
        getMacAddress();

        final response = await http.post(
            Uri.parse(
                '${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=${ipv6Address??imeiNumber??macAddress}&sn=$serialNumber&model=$modelName'),
            // '${Environment.urlApi}/login/authentification.php?code=$inputCode&mac=$macAddress&sn=$ipv6Address&model=$modelName'),

            headers: {
              'Accept': 'application/json',
            });

        String decryptedData = Environment.encryptDecrypt(response.body);

        print("decryptedData = ${decryptedData.toString()}");

        ResponseAuth responseAuth =
            ResponseAuth.fromJson(jsonDecode(decryptedData));

        print("responseAuth.status = ${responseAuth.status}");

        if (responseAuth.status.toString() == "1") {
          _loginSuccessSubject.add(true);
          localData.saveData("exp_date", responseAuth.expDate);
          localData.saveData("code", inputCode);

          localData.saveData("serial_number", serialNumber);
          localData.saveData("mac_address", macAddress);
          localData.saveData("ip_address", ipv6Address);
          localData.saveData("active_session", true);
          // secureStorage.persistenToken(inputCode);

          print("_loginSuccessSubject : ${_loginSuccessSubject.value}");
        } else {
          _errorSubject.add('Failed to login');
        }
      } else {
        status = await DeviceInfos().requestPhonePermission();
        if (!status.isGranted) {
          Get.snackbar(
            'Necessary Permission',
            "You have to enable the location permission to logged in",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorManager.red,
            colorText: ColorManager.white,
            duration: const Duration(seconds: 3),
          );
          if (status.isPermanentlyDenied) {
            SettingsViewModel().openSettings();
          }
        }
      }
    } catch (e) {
      _errorSubject.add('Error occurred: $e');
    } finally {
      print("_loginSuccessSubject finally: ${_loginSuccessSubject.value}");

      _isLoadingSubject.add(false);
    }

    return _loginSuccessSubject.value;
  }

  void dispose() {
    _isLoadingSubject.close();
    _errorSubject.close();
    _loginSuccessSubject.close();
  }

  void start() {
    getIpv4Address();
    getIpv6Address();
    getImeiNumber();
    getModelName();
  }

  void getMacAddress() async {
    try {
      macAddress = await _networkInfo.getWifiBSSID();
      print("mac address from void viewmodel = $macAddress");
    } on PlatformException catch (e) {
      macAddress = 'Failed to get Wifi BSSID';
    }
  }

  void getIpv6Address() async {
    try {
      ipv6Address = await _networkInfo.getWifiIPv6();
      print("ipv6 address from void viewmodel = $ipv6Address");
    } on PlatformException catch (e) {
      print('Failed to get Wifi IPV6');
    }
  }

  void getIpv4Address() async {
    try {
      ipv4Address = await DeviceInfos().getIpAddress();
      print("ipv4Address = $ipv4Address");
    } on PlatformException catch (e) {
      print('Failed to get IPv4 address');
    }
  }

  Future<void> getImeiNumber() async {
    late String platformVersion;

    platformVersion = await DeviceInformation.platformVersion;
    ClientInformation info = await ClientInformation.fetch();

    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      // Get client information

      print(
          "info.deviceId = ${info.deviceId}"); // c686dd0391ee1eef
      // print(info.osName); // iOS
      imeiNumber = await DeviceInformation.deviceIMEINumber;
      apiLevel = await DeviceInformation.apiLevel;
      print("imei number = $imeiNumber");
      print("api level = $apiLevel");
    } on PlatformException catch (e) {
      platformVersion = 'info.deviceId ${e.message}';
    }
  }

  void getModelName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        print("devise is Android = ${Platform.isAndroid}");
        print("devise is IOS = ${Platform.isIOS}");
        final androidInfo = await deviceInfo.androidInfo;

        late String platformVersion;
        platformVersion = await DeviceInformation.platformVersion;
        ClientInformation info = await ClientInformation.fetch();

        print("android info : ${androidInfo.toString()}");
        modelName = androidInfo.model;

        // macAddress = androidInfo.id;
        if (androidInfo.serialNumber != "unknown" &&
            androidInfo.serialNumber.isNotEmpty) {
          serialNumber = androidInfo.serialNumber;
          print("serial number is serialNumber = $serialNumber");
        } else {
          serialNumber = info.deviceId;
          print("serial number is id = $serialNumber");
        }
        // print("id view model = ${macAddress.toString()}");
        print("model name view model = $modelName");
      } else if (Platform.isIOS) {
        print("devise is Android = ${Platform.isAndroid}");
        print("devise is IOS = ${Platform.isIOS}");
        final iosInfo = await deviceInfo.iosInfo;
        modelName = iosInfo.utsname.machine;
        print("model name = $modelName");
      }
    } catch (e) {
      print("error of getModelName : ${e.toString()}");
    }
    // await Future.delayed(Duration(seconds: 1)); // Example delay

    // return modelName!;
    // return 'Example Model';
  }

  @override
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  Stream<String> get errorStream => _errorSubject.stream;

  @override
  Stream<bool> get loginSuccessStream => _loginSuccessSubject.stream;
}
*/
