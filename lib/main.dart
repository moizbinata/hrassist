import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prj1/screens/controllers/google_sign_in.dart';
import 'package:prj1/screens/views/CameraScreen.dart';
import 'package:prj1/splash_screen/SplashScreen.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:prj1/utils/speechController.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await GetStorage.init();
  cameras = await availableCameras();
// git config --global --add safe.directory G:/Upwork/prj1
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SpeechController speechController = Get.put(SpeechController());
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    print("moiz");
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Container(
              child: Text("Error"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print("connection state done");
          return LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return ChangeNotifierProvider(
                create: (context) => GoogleSignInProvider(),
                child: GetMaterialApp(
                  title: 'HRmove',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: Colors.lightBlue[800],
                    accentColor: Colors.cyan[600],
                    primarySwatch: Colors.amber,
                    buttonTheme: const ButtonThemeData(
                      buttonColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(),
                      textTheme: ButtonTextTheme.primary,
                    ),
                    textTheme: const TextTheme(
                      headline1: TextStyle(
                          fontSize: 72.0, fontWeight: FontWeight.bold),
                      headline6: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      bodyText2: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  home: SplashScreen(),
                ),
              );
            });
          });
        } else {
          print("not connecting");
          return MaterialApp(
            title: 'HRmove',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.lightBlue[800],
              accentColor: Colors.cyan[600],
              primarySwatch: Colors.amber,
              textTheme: GoogleFonts.latoTextTheme(),
            ),
            home: Container(
              child: Text("Not connecting"),
            ),
          );
        }
      },
    );
  }
}
