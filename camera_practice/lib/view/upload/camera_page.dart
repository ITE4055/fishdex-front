import 'package:camera/camera.dart';
import 'package:fishdex/view/upload/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                picture: picture,
              )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF98BAD5),
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(
            //   bottom: Radius.circular(20),
            // ),
          ),
          title: const Text(
            '카메라로 등록하기', // 텍스트 내용
            style: TextStyle(
              fontSize: 30, // 폰트 크기 설정
              fontFamily: 'Roboto', // 사용할 폰트 설정
              fontWeight: FontWeight.bold, // 폰트 굵기 설정
              fontStyle: FontStyle.italic, // 폰트 스타일 설정
              color: Colors.white, // 텍스트 색상 설정
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color(0xFFC6D3E3),

        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color(0xFF98BAD5), // border color same as background
                  width: 10.0, // border width
                ),
                right: BorderSide(
                  color: Color(0xFF98BAD5), // border color same as background
                  width: 10.0, // border width
                ),
              ),
            ),
            child: Stack(
                children: [
              (_cameraController.value.isInitialized)
                  ? CameraPreview(_cameraController)
                  : Container(
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        color: Color(0xff98bad5),
                    ),
                    child:
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(
                          child: IconButton(
                            onPressed: takePicture,
                            iconSize: 50,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            // icon: const Icon(Icons.circle, color: Colors.white),
                            icon: Transform.scale(
                              scale: 0.5,
                              child: Image.asset(
                                'lib/icons/fish.png',
                                color: Colors.white,
                              ))
                          )),
                    ]),
                  )),
            ]),
          ),
        ));
  }
}