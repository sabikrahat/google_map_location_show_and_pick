import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapDialog extends StatefulWidget {
  const ShowMapDialog({
    Key? key,
    required this.positions,
    required this.cameraPosition,
  }) : super(key: key);

  final List<Position> positions;
  final Position cameraPosition;

  @override
  _ShowMapDialogState createState() => _ShowMapDialogState();
}

class _ShowMapDialogState extends State<ShowMapDialog> {
  late LatLng _center;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    _center =
        LatLng(widget.cameraPosition.latitude, widget.cameraPosition.longitude);
    _cameraPosition =
        CameraPosition(target: _center, zoom: 18, tilt: 0, bearing: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      contentPadding: const EdgeInsets.all(10.0),
      content: GoogleMap(
        initialCameraPosition: _cameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: List.generate(
          widget.positions.length,
          (index) => Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(widget.positions[index].latitude,
                widget.positions[index].longitude),
            infoWindow: InfoWindow(
              title: index.toString(),
              snippet: '*',
            ),
          ),
        ).toSet(),
      ),
    );
  }
}
