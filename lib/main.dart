import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_radar/controllers/RFAuthController.dart';
import 'package:roomie_radar/models/UserModel.dart';
import 'package:roomie_radar/views/Static/RFSplashScreen.dart';
import 'package:roomie_radar/store/AppStore.dart';
import 'package:roomie_radar/utils/AppTheme.dart';
import 'package:roomie_radar/utils/RFConstant.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roomie_radar/firebase_options.dart';

AppStore appStore = AppStore();
UserModel? userModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  if (RFAuthController().isSignedIn()) {
    String uid = await RFAuthController().getUid();
    userModel = await RFAuthController().fetchUserDataFromFirestore(uid);
  }
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'Roomie Radar',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        home: const RFSplashScreen(),
      ),
    );
  }
}
