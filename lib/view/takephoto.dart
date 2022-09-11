// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:scannerx/view/scan4Text.dart';
import 'package:scannerx/view/scanASdoc.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  bool showPics = false;
  XFile image = XFile("");
  late NAlertDialog nDialog;
  bool flash = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    nDialog = NAlertDialog(
      onDismiss: () {
        setState(() {
          showPics = false;
        });
        File(image.path).delete();
      },
      title: Text("Image Caputured"),
      content: Text("scan as document or scan for text"),
      actions: [
        TextButton(onPressed: () => scan(true), child: Text("document")),
        TextButton(onPressed: () => scan(false), child: Text("for text")),
      ],
    );
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
                  child: Image(image: FileImage(File(image.path))),
                );
              }
              return GestureDetector(
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
                    child: CameraPreview(_controller),
                  ));
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
              title: Text("Please Wait"),
              message: Text("Caputuring Image"),
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
            setState(() {
              showPics = true;
            });
            diag.dismiss();
            // ignore: use_build_context_synchronously
            nDialog.show(context);
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

  void scan(bool doc) {
    Navigator.of(context).pop();
    if (doc) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            DisplayPictureScreen(imagePath: image.path, fromCam: true),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Scan4Text(imagePath: image.path, fromCam: true),
      ));
    }
  }
}
