// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannerx/view/scanAirtime.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appTheme.dart';
import '../statics_vars.dart';

class LoadAirtime extends StatefulWidget {
  const LoadAirtime({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  State<LoadAirtime> createState() => _LoadAirtimeState();
}

class _LoadAirtimeState extends State<LoadAirtime> {
  String prefix = "*555*";
  String val = "";
  late Future<String> getst;
  final key1 = GlobalKey();
  var txt = TextEditingController();
  bool get isDarkMode =>
      (MediaQuery.of(context).platformBrightness == Brightness.dark);
  Future<String> getAirtime() async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    final text = await textRecognizer.processImage(inputImage);
    for (var block in text.blocks) {
      var t = block.text.replaceAll(RegExp(r"\D+"), "");
      if (t.length == 16) {
        val = t;
        return "$prefix$t#";
      }
    }
    return "";
  }

  @override
  void initState() {
    txt.addListener(() {
      txt.text = "$prefix$val#";
    });
    getst = getAirtime();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: FloatingActionButton(
          tooltip: "Menu",
          key: key1,
          mini: true,
          onPressed: showminiMenu,
          child: Icon(Icons.menu, color: Colors.grey[100]),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
              future: getst,
              builder: (context, text) {
                if (text.connectionState == ConnectionState.done) {
                  if (text.data!.isEmpty) {
                    return const Center(child: Text("nothing to scan"));
                  }
                  txt.text = text.data!;
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),

                          // textfield

                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(.7)
                                    : Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold),
                            minLines: 1,
                            maxLines: 1,
                            controller: txt,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                        ClipboardData(text: txt.text))
                                    .then((value) {
                                  final sk = SnackBar(
                                    content: Text("copied to clipboard"),
                                    duration: Duration(milliseconds: 400),
                                    behavior: SnackBarBehavior.fixed,
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(sk);
                                });
                              },
                              child: Icon(Icons.copy)),
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: txt.text,
                                );
                                await launchUrl(launchUri);
                              },
                              child: Icon(Icons.call))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButton<String>(
                          value: prefix,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 8,
                          items: [
                            DropdownMenuItem(
                                value: "*555*", child: Text("MTN")),
                            DropdownMenuItem(
                                value: "*126*", child: Text("Airtel")),
                            DropdownMenuItem(
                                value: "*123*", child: Text("Glo")),
                          ],
                          onChanged: (s) {
                            setState(() {
                              txt.notifyListeners();
                              prefix = s!;
                              txt.text = "$prefix$val#";
                            });
                          }),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }

  Future<void> showminiMenu() async {
    final details = key1.currentContext!.findRenderObject() as RenderBox;
    var opt = await showMenu(
        context: context,
        constraints: const BoxConstraints(maxWidth: 60),
        initialValue: 0,
        position: RelativeRect.fromLTRB(
            details.localToGlobal(Offset.zero).dx,
            details.localToGlobal(Offset.zero).dy,
            details.localToGlobal(Offset.zero).dx,
            details.localToGlobal(Offset.zero).dy),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        items: [
          const PopupMenuItem(
              value: 4,
              height: 40,
              child: Icon(
                Icons.add_a_photo,
                color: kPrimaryColor,
              )),
          PopupMenuItem(
              value: 3,
              height: 40,
              child: Icon(
                Icons.file_open,
                color: kPrimaryColor,
              )),
          const PopupMenuItem(
              value: 2,
              height: 40,
              child: Icon(
                Icons.refresh_rounded,
                color: kPrimaryColor,
              )),
          const PopupMenuItem(
              value: 1,
              height: 40,
              child: Icon(
                Icons.home,
                color: kPrimaryColor,
              )),
        ]);
    if (opt == 4) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScanAirtime(camera: StaticVars.cameras.first)));
      return;
    }
    if (opt == 3) {
      var file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return;
      }
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 6, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.original],
        uiSettings: [
          AndroidUiSettings(
            statusBarColor: Colors.white.withOpacity(0),
            toolbarTitle: 'Crop airtime',
            toolbarWidgetColor: kPrimaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
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
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoadAirtime(imagePath: croppedFile.path)));
      return;
    }
    if (opt == 2) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoadAirtime(imagePath: widget.imagePath),
      ));
      return;
    }
    if (opt == 1) Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
