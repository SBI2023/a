import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/app/device_info.dart';
import 'package:iptv_sbi_v2/presentation/resources/styles_manager.dart';
import 'package:iptv_sbi_v2/presentation/ui/choice_splash/view/choice_splash_view.dart';
import 'package:iptv_sbi_v2/presentation/ui/home/view/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../data/storage/local_data.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../settings/view/settings_view.dart';
import '../viewmodel/signin_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _inputCodeController = TextEditingController();
  late LoginViewModel viewModel;
  late bool _successLogin = false;
  final FocusNode _rawKeyboardFocus = FocusNode();
  final FocusNode _inputCodeFocus = FocusNode();

  // final FocusNode _submitFocus = FocusNode();
  // final FocusNode _restoreFocus = FocusNode();
  // final FocusNode _infoFocus = FocusNode();

  // bool _isRestoreBtnFocus = true;
  // bool _isLoginBtnFocus = false;
  // bool _isInfoBtnFocus = false;
  // bool _isInputCodeFocus = false;
  int _selectedButtonIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    getPermission();
    // LocalData().destroyData("is_logged_in");
    viewModel = LoginViewModel();
    // Get MAC address and model name when view is initialized
    // viewModel.getMacAddress();
    viewModel.start();
    // initPlatformState();
    viewModel.loginSuccessStream.listen((isSuccess) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _successLogin = isSuccess;
        // print("isLoginSuccess from listen : $_successLogin");
      });
    });
    _inputCodeFocus.requestFocus();
    // FocusScope.of(context)
    //     .requestFocus(_rawKeyboardFocus);
  }

  void getPermission() async {
    if (LocalData().checkKey(AppConstants.phonePermissionStatus)) {
      PermissionStatus status =
          LocalData().getData(AppConstants.phonePermissionStatus);
      if (!status.isGranted) {
        await DeviceInfos().requestPhonePermission();
      } /*else {
        await DeviceInfos().requestPhonePermission();
      }*/
    }
  }

  @override
  void dispose() {
    viewModel.dispose();
    _inputCodeController.dispose();
    _rawKeyboardFocus.dispose();
    _inputCodeFocus.dispose();
    // _submitFocus.dispose();
    // _restoreFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive),
      child: RawKeyboardListener(
        focusNode: _rawKeyboardFocus,
        onKey: (RawKeyEvent event) async {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              /*if (_restoreFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_infoFocus);
                  // _submitFocus.requestFocus();
                });
              } else if (_submitFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_restoreFocus);
                  _inputCodeFocus.requestFocus();
                });
              } else if (_inputCodeFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_submitFocus);
                });
                // _codeFocus.requestFocus();
              } else {
                setState(() {
                  FocusScope.of(context).requestFocus(_submitFocus);
                });
              }*/
              // if(_selectedButtonIndex == 0){
              //   _inputCodeFocus.unfocus();
              //   setState(() {
              //     _selectedButtonIndex = 1;
              //   });
              // }

              setState(() {
                _selectedButtonIndex =
                    (_selectedButtonIndex == 3) ? 0 : _selectedButtonIndex + 1;

                if (_selectedButtonIndex == 0) {
                  FocusScope.of(context).requestFocus(_inputCodeFocus);
                  _inputCodeFocus.requestFocus();
                } else {
                  _inputCodeFocus.unfocus();
                }
              });
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              setState(() {
                _selectedButtonIndex =
                    (_selectedButtonIndex == 0) ? 3 : _selectedButtonIndex - 1;

                if (_selectedButtonIndex == 0) {
                  _inputCodeFocus.requestFocus();
                } else {
                  _inputCodeFocus.unfocus();
                }
              });
              /*if (_restoreFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_submitFocus);
                  // _submitFocus.requestFocus();
                });
              } else if (_submitFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_inputCodeFocus);
                  _inputCodeFocus.requestFocus();
                });
              } else if (_inputCodeFocus.hasFocus) {
                setState(() {
                  FocusScope.of(context).requestFocus(_infoFocus);
                });
                // _codeFocus.requestFocus();
              } else {
                setState(() {
                  FocusScope.of(context).requestFocus(_submitFocus);
                });
              }*/
              /*if (_isInputCodeFocus) {
                setState(() {
                  _isInputCodeFocus = false;
                  _inputCodeFocus.unfocus();
                  _isInfoBtnFocus = true;
                  _infoFocus.requestFocus();
                });
              } else if (_isLoginBtnFocus) {
                setState(() {
                  _isLoginBtnFocus = false;
                  _submitFocus.unfocus();
                  _isInputCodeFocus = true;
                  _inputCodeFocus.requestFocus();
                });
              } else if (_isRestoreBtnFocus) {
                setState(() {
                  _isRestoreBtnFocus = false;
                  _restoreFocus.unfocus();
                  _isLoginBtnFocus = true;
                  _submitFocus.requestFocus();
                });
              } else if (_isInfoBtnFocus) {
                setState(() {
                  _isInfoBtnFocus = false;
                  _infoFocus.unfocus();
                  _isRestoreBtnFocus = true;
                  _restoreFocus.requestFocus();
                });
              }*/
            } else if (event.logicalKey == LogicalKeyboardKey.select) {
              /*if (_submitFocus.hasFocus){
                final inputCode = _inputCodeController.text;
                bool isLoginSuccess = await viewModel.login(inputCode);

                if (isLoginSuccess) {
                  Get.to(() => const HomeView());
                }
              } else if (_restoreFocus.hasFocus) {
                Get.off(() => const ChoiceScreenView());
              } else if (_infoFocus.hasFocus) {
                Get.to(() => const SettingsView());
                // _codeFocus.requestFocus();
              }*/
              if (_selectedButtonIndex == 1) {
                final inputCode = _inputCodeController.text;
                bool isLoginSuccess = await viewModel.login(inputCode);

                if (isLoginSuccess) {
                  Get.to(() => const HomeView());
                }
              } else if (_selectedButtonIndex == 2) {
                Get.off(() => const ChoiceScreenView());
              } else if (_selectedButtonIndex == 3) {
                Get.to(() => const SettingsView());
                // _codeFocus.requestFocus();
              }
            } else {
              setState(() {
                FocusScope.of(context).requestFocus(_inputCodeFocus);
                _selectedButtonIndex = 0;
              });
            }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              // color: ColorManager.primary,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                /*borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),*/
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.01, 0.6, 0.75, 1],
                    colors: ColorManager.actionContainerColorBlue),
              ),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    ImageAssets.bgLoginScreen,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: StreamBuilder<bool>(
                        stream: viewModel.isLoadingStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          bool? isLoading = snapshot.data;
                          return Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .1,
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  child: Center(
                                    child: Image.asset(
                                        ImageAssets.alphaLogoSetting),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // _loginTextField(),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  // height: MediaQuery.of(context).size.height * 0.6,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextField(
                                    controller: _inputCodeController,
                                    focusNode: _inputCodeFocus,
                                    decoration: InputDecoration(
                                      hintText: "Enter your activation code",
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                          width: 3,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                          width: 2,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                          width: 2,
                                        ),
                                      ),
                                      hintStyle: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s22,
                                      ),
                                      filled: false,
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.red,
                                          width: 2,
                                        ),
                                      ),
                                      errorStyle: getSemiBoldStyle(
                                        color: ColorManager.red,
                                        fontSize: FontSize.s20,
                                      ),
                                      // errorText: "errrrr",
                                    ),
                                    cursorColor: ColorManager.white,
                                    textAlign: TextAlign.center,
                                    style: getBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s22,
                                    ),
                                    cursorWidth: 2,
                                    onSubmitted: (value) {
                                      _inputCodeFocus.unfocus();
                                      setState(() {
                                        _selectedButtonIndex = 1;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  // focusNode: _submitFocus,
                                  onTap: isLoading!
                                      ? null
                                      : () async {
                                          final inputCode =
                                              _inputCodeController.text;
                                          bool isLoginSuccess =
                                              await viewModel.login(inputCode);
                                          print(
                                              "_successLogin 2= $_successLogin");
                                          print(
                                              "isLoginSuccess 2= $isLoginSuccess");

                                          if (isLoginSuccess) {
                                            Get.to(() => const HomeView());
                                          }
                                          // Temporary for test
                                          // Get.to(()=>MoviesGridView(nameSlider: "test", repositoryFunction: movieService.getAllMovies()));
                                          // SerieByCategoryInfosModel slider = SerieByCategoryInfosModel(id: 2, name: 'test serie', categoryId: "1");
                                          // Get.to(()=> DetailsSerie(slider: slider, seriesHomeViewModel: SeriesHomeViewModel(serieService.getCategoriesSeries()),));
                                        },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .35,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: (_selectedButtonIndex ==
                                              1) /*_submitFocus.hasFocus*/
                                          ? <BoxShadow>[
                                              BoxShadow(
                                                color: ColorManager
                                                    .selectedNavBarItem,
                                                offset: const Offset(2, 4),
                                                blurRadius: 5,
                                                spreadRadius: 5,
                                              ),
                                            ]
                                          : null,
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors:
                                            ColorManager.backgroundColorLight,
                                      ),
                                    ),
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            'Login',
                                            style: getRegularStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s20,
                                                isUnderline:
                                                    (_selectedButtonIndex ==
                                                        1) /*_submitFocus.hasFocus*/),
                                          ),
                                  ),
                                ),
                                // const SizedBox(height: 30),
                                // // const DividerView(),
                                const SizedBox(height: 30),
                                InkWell(
                                  // focusNode: _restoreFocus,
                                  onTap: () =>
                                      Get.off(() => const ChoiceScreenView()),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: (_selectedButtonIndex ==
                                              2) /*_restoreFocus.hasFocus*/
                                          ? <BoxShadow>[
                                              BoxShadow(
                                                // color: Colors.grey.shade200,
                                                color: ColorManager
                                                    .selectedNavBarItem,
                                                offset: const Offset(0, 0),
                                                blurRadius: 25,
                                                spreadRadius: 15,
                                              ),
                                            ]
                                          : null,
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors:
                                            ColorManager.backgroundColorLight,
                                      ),
                                    ),
                                    child: Text(
                                      'Restore',
                                      style: getRegularStyle(
                                          color: ColorManager.black,
                                          fontSize: FontSize.s20,
                                          isUnderline: (_selectedButtonIndex ==
                                              2) /*_restoreFocus.hasFocus*/),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .055,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: OutlinedButton(
                      // focusNode: _infoFocus,
                      onPressed: () => Get.to(() => const SettingsView()),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: ColorManager.yellow)),
                        backgroundColor: MaterialStatePropertyAll(
                          (_selectedButtonIndex == 3)
                              ? ColorManager.yellow
                              : ColorManager.transparent,
                        ),
                        foregroundColor: MaterialStatePropertyAll(ColorManager.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                      ),
                      child: Text(
                        "Info",
                        style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget _loginTextField() {
//   return ;
// }
}
