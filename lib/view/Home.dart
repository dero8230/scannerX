// ignore_for_file: file_names, prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannerx/view/scan4Text.dart';
import 'package:scannerx/view/scanAirtime.dart';

import '../appTheme.dart';
import 'scanASdoc.dart';
import 'takephoto.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.cameraDescription})
      : super(key: key);
  final CameraDescription cameraDescription;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> alignment;
  String fromFilePath = "";
  void startCam() async {
    animationController.reverse().whenComplete(() async {
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) =>
            TakePictureScreen(camera: widget.cameraDescription),
      ))
          .then((value) {
        animationController.forward();
      });
    });
  }

  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    print(Colors.grey.shade100.toString());
    super.initState();
    animationController = AnimationController(
        reverseDuration: Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 300),
        vsync: this);
    alignment = Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 1000));
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              // scan for text button
              Align(
                alignment: Alignment(-1 + alignment.value, 0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF5C5EDD).withOpacity(0.6),
                            offset: const Offset(1.1, 4.0),
                            blurRadius: 8.0),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(colors: const [
                        Color(0xFF738AE6),
                        Color(0xFF5C5EDD),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: InkWell(
                        splashColor: kPrimaryColor.withGreen(60),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(54),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        onTap: selectImage2,
                        child: SizedBox(
                          height: screenHeight / 4.36363636364,
                          width: screenWidth / 2.618181818181818,
                          child: Center(
                            child: Stack(
                              children: const [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.text_fields,
                                    size: 50,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.7),
                                  child: Text("Scan for Text",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // scan document button
              Align(
                alignment:
                    Alignment(-1 * alignment.value, -1 * alignment.value),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF5C5EDD).withOpacity(0.6),
                            offset: const Offset(1.1, 4.0),
                            blurRadius: 8.0),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(colors: const [
                        Color(0xFF738AE6),
                        Color(0xFF5C5EDD),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: InkWell(
                        splashColor: kPrimaryColor.withGreen(60),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(54),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        onTap: selectImage,
                        child: SizedBox(
                          height: screenHeight / 4.36363636364,
                          width: screenWidth / 2.618181818181818,
                          child: Center(
                            child: Stack(
                              children: const [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.document_scanner,
                                    size: 50,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.7),
                                  child: Text("Scan Document",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // scan for airtime button
              Align(
                alignment: Alignment(1, 1 * alignment.value),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF5C5EDD).withOpacity(0.6),
                            offset: const Offset(1.1, 4.0),
                            blurRadius: 8.0),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(colors: const [
                        Color(0xFF738AE6),
                        Color(0xFF5C5EDD),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(54),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: InkWell(
                        splashColor: kPrimaryColor.withGreen(60),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(54),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        onTap: startCamAirtime,
                        child: SizedBox(
                          height: screenHeight / 4.36363636364,
                          width: screenWidth / 2.618181818181818,
                          child: Center(
                            child: Stack(
                              children: const [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.settings_overscan_outlined,
                                    size: 50,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.7),
                                  child: Text("Scan Airtime(NG)",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: startCam,
        tooltip: 'Start Camera',
        child: Icon(
          Icons.add_a_photo,
          color: Colors.grey[100],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void startCamAirtime() async {
    animationController.reverse();
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => ScanAirtime(camera: widget.cameraDescription),
    ))
        .then((value) {
      animationController.forward();
    });
  }

  void selectImage() async {
    animationController.reverse();
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      animationController.forward();
      return;
    }
    fromFilePath = file.path;
    scanImage(true);
  }

  void selectImage2() async {
    animationController.reverse();
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      animationController.forward();
      return;
    }
    fromFilePath = file.path;
    scanImage(false);
  }

  void scanImage(bool doc) {
    if (fromFilePath.isEmpty) {
      animationController.forward();
      return;
    }
    if (doc) {
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) =>
            DisplayPictureScreen(imagePath: fromFilePath, fromCam: false),
      ))
          .then((value) {
        animationController.forward();
      });
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => Scan4Text(imagePath: fromFilePath, fromCam: false),
    ))
        .then((value) {
      animationController.forward();
    });
  }
}
