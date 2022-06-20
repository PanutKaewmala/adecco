import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool showRearCamera;
  const CameraScreen(
      {Key? key, required this.cameras, required this.showRearCamera})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera);
    super.initState();
  }

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 1;
  File? capturedImages;

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    if (Platform.isIOS) {
      _controller.setFlashMode(FlashMode.off);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: appbarNoBackground(
          color: AppTheme.black,
          iconButton: widget.showRearCamera
              ? IconButton(
                  icon: const Icon(
                    Icons.camera_rear,
                    color: AppTheme.white,
                  ),
                  onPressed: () {
                    selectedCamera == 1
                        ? selectedCamera = 0
                        : selectedCamera = 1;

                    setState(() {
                      initializeCamera(selectedCamera);
                    });
                  },
                )
              : Container()),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: capturedImages != null
                      ? Image.file(capturedImages!)
                      : CameraPreview(_controller),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    bottom: true,
                    child: Container(
                        height: 30.w,
                        color: AppTheme.black,
                        child: capturedImages != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        capturedImages = null;
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      alignment: Alignment.center,
                                      color: AppTheme.black,
                                      child: text(Texts.retake,
                                          fontSize: AppFontSize.mediumL,
                                          color: AppTheme.white),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back(result: capturedImages);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      alignment: Alignment.center,
                                      color: AppTheme.black,
                                      child: text(Texts.done,
                                          fontSize: AppFontSize.mediumL,
                                          color: AppTheme.white),
                                    ),
                                  )
                                ],
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await _initializeControllerFuture;
                                  var xFile = await _controller.takePicture();
                                  setState(() {
                                    capturedImages = File(xFile.path);
                                    debugPrint("file: ${xFile.path}");
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomPaint(
                                        painter: DrawCircle(paintSize: 35),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
            );
          }
        },
      ),
    );
  }
}
