import 'dart:async';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class MapView extends StatelessWidget {
  final LatLng latLng;
  const MapView({Key? key, required this.latLng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller = Completer();
    CameraPosition _initCameraPosition =
        CameraPosition(target: latLng, zoom: 17);
    List<Marker> _markers = <Marker>[
      Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
      )
    ];
    return AbsorbPointer(
      absorbing: true,
      child: GoogleMap(
        mapType: MapType.normal,
        mapToolbarEnabled: false,
        initialCameraPosition: _initCameraPosition,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

class MapViewAction extends StatefulWidget {
  final LatLng latLng;
  final void Function(LatLng) onTap;
  const MapViewAction({Key? key, required this.latLng, required this.onTap})
      : super(key: key);

  @override
  State<MapViewAction> createState() => _MapViewActionState();
}

class _MapViewActionState extends State<MapViewAction> {
  final List<Marker> _markers = <Marker>[];
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng position;
  late CameraPosition _initCameraPosition;
  late CameraPosition _moveCameraPosition;

  @override
  void initState() {
    position = widget.latLng;
    _markers.add(Marker(
      draggable: false,
      markerId: MarkerId(position.toString()),
      position: position,
    ));
    _initCameraPosition = CameraPosition(target: position, zoom: 17);
    _moveCameraPosition = _initCameraPosition;
    super.initState();
  }

  void _handleTap(LatLng point) {
    position = point;
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        draggable: false,
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    });
    _goToMarker();
    widget.onTap(point);
  }

  Future<void> _goToMarker() async {
    final GoogleMapController controller = await _controller.future;
    _moveCameraPosition = CameraPosition(target: position, zoom: 17);
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_moveCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
