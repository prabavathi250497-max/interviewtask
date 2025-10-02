
import 'package:assessment/routes/app_routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/app_export.dart';
import 'core/utils/navigator_service.dart';
import 'core/utils/pref_utils.dart';
import 'data/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
late List<CameraDescription> cameras;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    print('Firebase init failed: $e\n$st');
  }
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("Error fetching cameras: $e");
    cameras = [];
  }
  requestPermission();
  //requestLocationPermission();
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
  ]).then((value) {

    final authRepository = AuthRepository();

    runApp(MyApp(authRepository: authRepository,cameras: cameras));
  });

  // print(decrypted);
}





Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (!status.isGranted) {
    print("requestLocationPermission Denied");
    // Handle permission denied
  }
}







void requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    Permission.phone,
    Permission.location,
    Permission.camera,
    Permission.storage,
  ].request();

  statuses.values.forEach((element) async {});
}



class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final List<CameraDescription> cameras;
  const MyApp({super.key,required this.authRepository, required this.cameras});
  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) =>
          ThemeBloc(ThemeState(themeType: PrefUtils().getThemeData())),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            // theme: theme,
            title: 'sathustechnology',
            navigatorKey: NavigatorService.navigatorKey,
            debugShowCheckedModeBanner: false,

            supportedLocales: [Locale('en', '')],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
            //home:RateCard(),
          );
        },
      ),
    );
    // return RepositoryProvider.value(
    //   value: authRepository,
    //   child: BlocProvider(
    //     create: (context) => AuthBloc(authRepository: authRepository),
    //     child: MaterialApp(
    //       title: 'Video ',
    //       debugShowCheckedModeBanner: false,
    //       theme: ThemeData(primarySwatch: Colors.indigo),
    //       initialRoute: '/',
    //
    //       routes: {
    //         '/': (_) => LoginScreen(),
    //         '/home': (_) => Video(),
    //       },
    //     ),
    //   ),
    // );

  }
}
