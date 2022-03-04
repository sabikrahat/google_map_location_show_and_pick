import 'package:flutter/material.dart';
import '../../../api/geolocator_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationDialog extends StatefulWidget {
  const PickLocationDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ShowMapPopUpState createState() => _ShowMapPopUpState();
}

class _ShowMapPopUpState extends State<PickLocationDialog> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isError = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text('Pick a Location', textAlign: TextAlign.center),
      contentPadding: const EdgeInsets.all(10.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<Position>(
                future: GeoLocatorApi().getCurrentLocation,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  Position position = snapshot.data!;
                  return GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 18,
                      tilt: 0,
                      bearing: 0,
                    ),
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    onLongPress: (latlang) {
                      _addMarkerLongPressed(
                          latlang); //we will call this function when pressed on the map
                    },
                    markers: Set<Marker>.of(markers.values),
                  );
                }),
          ),
          if (isError)
            const Text(
              'No Position Selected',
              style: TextStyle(color: Colors.red),
            ),
          if (markers.values.isNotEmpty)
            Text(
                'Latitude: ${markers.values.isEmpty ? '' : markers.values.first.position.latitude}'),
          if (markers.values.isNotEmpty)
            Text(
                'Longitude: ${markers.values.isEmpty ? '' : markers.values.first.position.longitude}'),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            if (markers.values.isNotEmpty) {
              Navigator.pop(context, markers.values.first.position);
            } else {
              setState(() {
                isError = true;
              });
            }
          },
        ),
      ],
    );
  }

  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      isError = false;
      MarkerId markerId = const MarkerId('RANDOM_ID');
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position:
            latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: const InfoWindow(
          title: 'Marker here',
          snippet: 'This looks good',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    // GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
  }
}
