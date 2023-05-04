import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/repositories/settings_repo.dart';
import '../../../../domain/models/settings_model.dart';
import '../../../base/base_viewmodel.dart';
import '../../../resources/constants_manager.dart';

class SettingsViewModel extends BaseViewModel
    with SettingsViewModelInputs, SettingsViewModelOutputs {

  final SettingsRepository _settingsRepository = SettingsRepository();

  final _selectedItemIndexController = BehaviorSubject<int>();
  final _permissionStatusController = BehaviorSubject<PermissionStatus>();


  final _SettingsDataStreamController = BehaviorSubject<SettingsModel>();

  @override
  ValueStream<SettingsModel> get SettingsDataStream =>
      _SettingsDataStreamController.stream;

  late List<String> listMenuItems;
  late List<String> listMenuInformations;
  late List<String> listOfInformations;
  final Uri _url = Uri.parse(AppConstants.alphaIptvUrl);

  Stream<int> get selectedItemIndex => _selectedItemIndexController.stream;
  Stream<PermissionStatus> get getPermissionStatus => _permissionStatusController.stream;

  void onItemClicked(int index) {
    _selectedItemIndexController.sink.add(index);
  }

  @override
  Function() get fetchSettingsData => _fetchSettingsData;

  void _fetchSettingsData() async {
    final settingsData = _settingsRepository.fetchSettingsItems();
    _SettingsDataStreamController.sink.add(settingsData);
    listMenuItems = settingsData.listMenuItems;
    listMenuInformations = settingsData.listMenuInformations;
    listOfInformations = settingsData.listOfInformations;
  }

  // Launch URL
  Function() get launchUrlWebsite => _launchUrl;

  void _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

// Open device settings
  void openSettings() async {
    try{
      openAppSettings();
      // OpenSettings.openDeviceInfoSetting();
    }on Exception catch(e){
      // throw 'Could not open device settings.';
      print("'Could not open device settings.'");
      throw e.toString();
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatusController.sink.add(status);
  }

  @override
  void start() {
    fetchSettingsData();
  }

  @override
  void dispose() {
    _selectedItemIndexController.close();
    _SettingsDataStreamController.close();
  }
}

abstract class SettingsViewModelInputs {
  late Function() fetchSettingsData;
}

abstract class SettingsViewModelOutputs {
  ValueStream<SettingsModel> get SettingsDataStream;
}
