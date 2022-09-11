import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:scannerx/view/Home.dart';

import '../appTheme.dart';
import '../statics_vars.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    /*opacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });*/
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool get isDarkMode =>
      (MediaQuery.of(context).platformBrightness == Brightness.dark);
  void navigationPage(CameraDescription camera) {
    var page = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MyHomePage(cameraDescription: camera),
        transitionDuration: const Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, -1);
          const end = Offset.zero;
          const curve = Curves.bounceOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    Navigator.pushReplacement(context, page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:
              isDarkMode ? const Color(0xFF2D2B2B) : const Color(0xFFFFF8F8)),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Lottie.asset(
                    isDarkMode
                        ? "assets/splashDark.json"
                        : "assets/splash.json",
                    controller: controller, onLoaded: (composition) {
                  controller.forward().then((_) async {
                    final cameras = await availableCameras();
                    StaticVars.cameras = cameras;
                    final mainCam = cameras.first;
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
                        overlays: [SystemUiOverlay.top]);
                    navigationPage(mainCam);
                  });
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: kPrimaryColor),
                      children: [
                        TextSpan(
                            text: 'Powered by ',
                            style: TextStyle(color: kPrimaryColor)),
                        TextSpan(
                            text: 'AGB',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
