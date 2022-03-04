import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_show_and_pick/api/geolocator_api.dart';
import 'package:google_map_location_show_and_pick/popups/pick_location_popup.dart';
import 'package:google_map_location_show_and_pick/popups/show_location_popup.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currPosition;
  String? lat;
  String? long;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick and Show Location'),
      ),
      body: FutureBuilder<Position>(
          future: GeoLocatorApi().getCurrentLocation,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            lat = snapshot.data?.latitude.toString();
            long = snapshot.data?.longitude.toString();
            currPosition = snapshot.data;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Latitude: $lat', textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text('Longitude: $long', textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    CustomButton(
                        label: "Pick a Location",
                        onTap: () async {
                          LatLng? latLng = await showModal(
                              context: context,
                              builder: (context) => const PickLocationDialog());
                          if (latLng != null) {
                            setState(() {
                              lat = latLng.latitude.toString();
                              long = latLng.longitude.toString();
                            });
                          }
                        }),
                    const SizedBox(height: 10),
                    CustomButton(
                      onTap: () async => await showModal(
                          context: context,
                          builder: (context) => ShowMapDialog(
                              cameraPosition: currPosition!,
                              positions: [currPosition!])),
                      label: "Show the Location",
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.0,
        width: 260.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[100],
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
