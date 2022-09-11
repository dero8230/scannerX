// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannerx/statics_vars.dart';
import 'package:scannerx/view/takephoto.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../appTheme.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final bool fromCam;
  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.fromCam});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List<TextBlock> block = [];
  final key1 = GlobalKey();
  bool showPanel = true;
  late Future<String> getst;
  final txt = TextEditingController();
  bool isdone = true;
  final pcon = PanelController();
  bool get isDarkMode =>
      (MediaQuery.of(context).platformBrightness == Brightness.dark);
  @override
  void dispose() {
    if (widget.fromCam) {
      File(widget.imagePath).delete();
    }
    txt.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getst = getstring();
    super.initState();
  }

  Future<String> getstring() async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    final text = await textRecognizer.processImage(inputImage);
    txt.text = text.text;
    block = text.blocks;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: 500));
      if (pcon.isAttached) pcon.open();
    });
    return text.text;
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
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SlidingUpPanel(
        onPanelSlide: (position) {
          if (position < 0.5) {
            setState(() {});
          }
        },
        onPanelOpened: () {
          setState(() {});
        },
        onPanelClosed: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        panelBuilder: (sc) => Stack(children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
            ),
            child: FutureBuilder<String>(
              future: getst,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (block.isEmpty) {
                    return Align(
                        alignment: Alignment.center,
                        child: Text(
                          "no text found",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                              fontSize: 16),
                        ));
                  }
                  return Container(
                    decoration: BoxDecoration(
                        color: isDarkMode ? kBgColorDark : kBgColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),

                      // textfield

                      child: TextField(
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.white.withOpacity(.7)
                                : Colors.black.withOpacity(0.7)),
                        minLines: 1,
                        maxLines: 37,
                        controller: txt,
                        scrollController: sc,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(maxHeight: 4, maxWidth: 35),
                decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // copy btn

          if (pcon.isAttached)
            AnimatedAlign(
              alignment: pcon.isPanelOpen
                  ? Alignment.bottomCenter
                  : Alignment.topRight,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                    onPressed: (() {
                      Clipboard.setData(ClipboardData(text: txt.text))
                          .then((value) {
                        final sk = SnackBar(
                          content: Text("copied to clipboard"),
                          duration: Duration(milliseconds: 200),
                          behavior: SnackBarBehavior.fixed,
                        );

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(sk);
                        return;
                      });
                    }),
                    child: Text("copy all")),
              ),
            )
          else
            SizedBox.shrink(),
        ]),
        snapPoint: 0.3,
        minHeight: showPanel ? 50 : 0,
        color: isDarkMode ? kBgColorDark : kBgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        controller: pcon,
        maxHeight: MediaQuery.of(context).size.height,
        body: GestureDetector(
          onTap: () {
            if (pcon.isAttached && !pcon.isPanelClosed) {
              pcon.close();
            }
          },
          onVerticalDragUpdate: (details) {
            if (pcon.isAttached &&
                details.primaryDelta! > 0 &&
                pcon.isPanelClosed) {
              setState(() {
                showPanel = false;
              });
              return;
            }
            if (pcon.isAttached && details.primaryDelta! < 0) {
              pcon.open();
              if (!showPanel) showPanel = true;
              return;
            }
            if (pcon.isAttached &&
                details.primaryDelta! > 0 &&
                !pcon.isPanelClosed) {
              pcon.close();
              return;
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(widget.imagePath),
                          width: MediaQuery.of(context).size.width - 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showminiMenu() async {
    final details = key1.currentContext!.findRenderObject() as RenderBox;
    var opt = await showMenu(
        context: context,
        constraints: BoxConstraints(maxWidth: 60),
        initialValue: 0,
        position: RelativeRect.fromLTRB(
            details.localToGlobal(Offset.zero).dx,
            details.localToGlobal(Offset.zero).dy,
            details.localToGlobal(Offset.zero).dx,
            details.localToGlobal(Offset.zero).dy),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        items: [
          PopupMenuItem(
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
          PopupMenuItem(
              value: 2,
              height: 40,
              child: Icon(
                Icons.refresh_rounded,
                color: kPrimaryColor,
              )),
          PopupMenuItem(
              value: 1,
              height: 40,
              child: Icon(
                Icons.home,
                color: kPrimaryColor,
              )),
        ]);
    if (opt == 4) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TakePictureScreen(camera: StaticVars.cameras.first)));
      return;
    }
    if (opt == 3) {
      var file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return;
      }
      final fromFilePath = file.path;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            DisplayPictureScreen(imagePath: fromFilePath, fromCam: false),
      ));
      return;
    }
    if (opt == 2) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            DisplayPictureScreen(imagePath: widget.imagePath, fromCam: false),
      ));
      return;
    }
    if (opt == 1) Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
