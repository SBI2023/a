import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../data/storage/local_data.dart';
import '../../../resources/constants_manager.dart';

import '../../../../app/device_info.dart';
import '../../../../data/repositories/choice_screen_repo.dart';
import '../../../../domain/models/choice_screen_model.dart';
import '../../../base/base_viewmodel.dart';


class ChoiceScreenViewModel extends BaseViewModel
    with ChoiceViewModelInputs, ChoiceViewModelOutputs {

  final ChoiceScreenRepository _choiceScreenRepository = ChoiceScreenRepository();

  final _selectedIBoxIndexController = BehaviorSubject<int>();

  final _ChoiceScreenDataStreamController = BehaviorSubject<ChoiceScreenModel>();


  @override
  ValueStream<ChoiceScreenModel> get ChoiceScreenDataStream => _ChoiceScreenDataStreamController.stream;

  late List<BoxModel> listOfBoxs;


  Stream<int> get selectedBoxIndex => _selectedIBoxIndexController.stream;


  void onItemClicked(int index) {
    _selectedIBoxIndexController.sink.add(index);
    print("_selectedIBoxIndexController.value = ${_selectedIBoxIndexController.value}");
  }

  @override
  Function() get fetchChoiceScreenData => _fetchChoiceScreenData;

  void _fetchChoiceScreenData() async {
    final choiceScreenData = _choiceScreenRepository.fetchBoxsData();
    _ChoiceScreenDataStreamController.sink.add(choiceScreenData);
    listOfBoxs = choiceScreenData.boxs;
  }

  void _getPermissions() async{
    // Location permission for Mac address
    if (LocalData().checkKey(AppConstants.phonePermissionStatus)) {
      PermissionStatus status =
      LocalData().getData(AppConstants.phonePermissionStatus);
      if (!status.isGranted) {
        await DeviceInfos().requestPhonePermission();
      }
    }else {
      await DeviceInfos().requestPhonePermission();
    }
    //
  }
  @override
  void start() {
    _getPermissions();
    fetchChoiceScreenData();
  }

  @override
  void dispose() {
    _selectedIBoxIndexController.close();
    _ChoiceScreenDataStreamController.close();
  }


}

abstract class ChoiceViewModelInputs {
  late Function() fetchChoiceScreenData;
}

abstract class ChoiceViewModelOutputs {
  ValueStream<ChoiceScreenModel> get ChoiceScreenDataStream;
}
