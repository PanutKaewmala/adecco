import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:flutter/rendering.dart';

import 'marker_widget.dart';

class MapViewCustom extends StatefulWidget {
  final LatLng latLng;
  const MapViewCustom({Key? key, required this.latLng}) : super(key: key);

  @override
  State<MapViewCustom> createState() => _MapViewCustomState();
}

class _MapViewCustomState extends State<MapViewCustom> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _initCameraPosition;
  final List<Marker> _markers = <Marker>[];
  late BitmapDescriptor pinLocationIcon;
  late LatLng position;
  final GlobalKey _iconKey = GlobalKey();

  Future<Uint8List> _capturePng(GlobalKey iconKey) async {
    if (iconKey.currentContext == null) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng(iconKey);
    }

    RenderRepaintBoundary boundary =
        iconKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    await Future.delayed(const Duration(milliseconds: 20));
    _capturePng(iconKey);

    ui.Image image = await boundary.toImage(pixelRatio: 2.5);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  void _getMarkerBitmaps() async {
    Future.delayed(const Duration(seconds: 1), () async {
      final Uint8List imageData = await _capturePng(_iconKey);
      setState(() {
        pinLocationIcon = BitmapDescriptor.fromBytes(imageData);
        _markers.add(Marker(
            draggable: false,
            markerId: MarkerId(position.toString()),
            position: position,
            icon: pinLocationIcon));
      });
    });
  }

  @override
  void initState() {
    position = widget.latLng;
    _initCameraPosition = CameraPosition(target: widget.latLng, zoom: 18);
    _getMarkerBitmaps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child:
                  RepaintBoundary(key: _iconKey, child: const CustomMarker())),
          GoogleMap(
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            initialCameraPosition: _initCameraPosition,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ),
    );
  }
}

class MapViewCustomAction extends StatefulWidget {
  final LatLng latLng;
  final void Function(LatLng) onTap;
  const MapViewCustomAction(
      {Key? key, required this.latLng, required this.onTap})
      : super(key: key);

  @override
  State<MapViewCustomAction> createState() => _MapViewCustomActionState();
}

class _MapViewCustomActionState extends State<MapViewCustomAction> {
  final List<Marker> _markers = <Marker>[];
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng position;
  late CameraPosition _initCameraPosition;
  late CameraPosition _moveCameraPosition;
  final GlobalKey _iconKey = GlobalKey();
  late BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    position = widget.latLng;
    _initCameraPosition = CameraPosition(target: position, zoom: 18);
    _moveCameraPosition = _initCameraPosition;
    _getMarkerBitmaps();
    super.initState();
  }

  Future<Uint8List> _capturePng(GlobalKey iconKey) async {
    if (iconKey.currentContext == null) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng(iconKey);
    }

    RenderRepaintBoundary boundary =
        iconKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    await Future.delayed(const Duration(milliseconds: 20));
    _capturePng(iconKey);

    ui.Image image = await boundary.toImage(pixelRatio: 2.5);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  void _handleTap(LatLng point) {
    position = point;
    setState(() {
      _markers.clear();
      _markers.add(Marker(
          draggable: false,
          markerId: MarkerId(point.toString()),
          position: point,
          icon: pinLocationIcon));
    });
    _goToMarker();
    widget.onTap(point);
  }

  Future<void> _goToMarker() async {
    final GoogleMapController controller = await _controller.future;
    _moveCameraPosition = CameraPosition(target: position, zoom: 18);
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_moveCameraPosition));
  }

  void _getMarkerBitmaps() async {
    Future.delayed(const Duration(seconds: 1), () async {
      final Uint8List imageData = await _capturePng(_iconKey);
      setState(() {
        pinLocationIcon = BitmapDescriptor.fromBytes(imageData);
        _markers.add(Marker(
            draggable: false,
            markerId: MarkerId(position.toString()),
            position: position,
            icon: pinLocationIcon));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomCenter,
            child: RepaintBoundary(key: _iconKey, child: const CustomMarker())),
        GoogleMap(
          mapType: MapType.normal,
          mapToolbarEnabled: false,
          initialCameraPosition: _initCameraPosition,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: _handleTap,
        ),
        Positioned(
          right: 5.w,
          top: 45.h,
          child: FloatingActionButton(
            child: const Icon(Icons.man_sharp, color: AppTheme.white),
            backgroundColor: AppTheme.mainRed,
            onPressed: () {
              _handleTap(widget.latLng);
            },
          ),
        ),
      ],
    );
  }
}
