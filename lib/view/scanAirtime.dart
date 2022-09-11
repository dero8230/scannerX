// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:scannerx/view/loadAirtime.dart';

import '../appTheme.dart';

class ScanAirtime extends StatefulWidget {
  const ScanAirtime({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;

  @override
  State<ScanAirtime> createState() => _ScanAirtimeState();
}

class _ScanAirtimeState extends State<ScanAirtime> {
  bool showPics = false;
  XFile image2 = XFile("");
  XFile image = XFile("");
  late NAlertDialog nDialog;
  bool flash = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );
    _controller.setFlashMode(FlashMode.off);
    _controller.setFocusMode(FocusMode.auto);
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(FlashMode.off);
    _controller.setFocusMode(FocusMode.auto);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Builder(builder: (context) {
              if (showPics) {
                return Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child:
                      Center(child: Image(image: FileImage(File(image2.path)))),
                );
              }
              return Stack(
                children: [
                  GestureDetector(
                      onDoubleTap: () {
                        if (flash) {
                          _controller.setFlashMode(FlashMode.off);
                          flash = !flash;
                        } else {
                          _controller.setFlashMode(FlashMode.torch);
                          flash = !flash;
                        }
                      },
                      onTapDown: (details) {
                        _controller.setFocusMode(FocusMode.locked);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: CameraPreview(
                          _controller,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                width: _controller.value.previewSize!.width,
                                height:
                                    _controller.value.previewSize!.height / 2 -
                                        40,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                width: _controller.value.previewSize!.width,
                                height:
                                    _controller.value.previewSize!.height / 2 -
                                        40,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                width:
                                    _controller.value.previewSize!.width / 17.7,
                                height: _controller.value.previewSize!.height /
                                    12.33,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                width:
                                    _controller.value.previewSize!.width / 17.7,
                                height: _controller.value.previewSize!.height /
                                    12.33,
                              ),
                            ),
                            Align(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 4)),
                                height:
                                    _controller.value.previewSize!.height / 12,
                                width: _controller.value.previewSize!.width / 5,
                              ),
                            ),
                          ]),
                        ),
                      )),
                  Align(
                    alignment: const Alignment(1, 0.7),
                    child: FloatingActionButton(
                      heroTag: "nothing",
                      onPressed: loadAirtimeFromFile,
                      child: Icon(
                        Icons.file_open,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-1, 0.7),
                    child: FloatingActionButton(
                      heroTag: "nothing2",
                      onPressed: Navigator.of(context).pop,
                      child:
                          Icon(Icons.cancel_outlined, color: Colors.grey[100]),
                    ),
                  )
                ],
              );
            });
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          var diag = ProgressDialog(context,
              title: const Text("Please Wait"),
              message: const Text("Capturing Image"),
              dismissable: false);
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            diag.show();
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            final imagex = await _controller.takePicture();
            image = imagex;
            scan();
            diag.dismiss();
            // ignore: use_build_context_synchronously

            print(image.path);
          } on Exception catch (e) {
            diag.dismiss();
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: Icon(Icons.camera_alt, color: Colors.grey[100]),
      ),
    );
  }

  Future<void> scan() async {
    image2 = XFile(await _resizePhoto(image.path));
    setState(() {
      showPics = true;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoadAirtime(imagePath: image2.path),
    ));
  }

  void loadAirtimeFromFile() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 6, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          statusBarColor: Colors.white.withOpacity(0),
          showCropGrid: false,
          toolbarTitle: 'Crop airtime',
          toolbarWidgetColor: kPrimaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Crop airtime',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          aspectRatioLockDimensionSwapEnabled: true,
          hidesNavigationBar: true,
        ),
      ],
    );
    if (croppedFile == null) {
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoadAirtime(imagePath: croppedFile.path)));
    return;
  }

  Future<String> _resizePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int width = properties.width!;
    int height = properties.height!;
    print(width);
    print(height);
    print((width / 2) - 100);
    var offset = (properties.height! - properties.width!) / 2;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath,
        ((width / 2.10989010989)).round(),
        (height / 7.2).round(),
        ((width / 19.2)).round(),
        (height / 1.44).round());
    print(croppedFile.path);
    return croppedFile.path;
  }
}
