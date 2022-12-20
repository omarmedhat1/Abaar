import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double _defaultLat = 31.0;
  static const double _defaultLng = 31.0;
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(_defaultLat, _defaultLng),
    zoom: 10,
  );
  Set<Marker> markers = {};
  Future<void> setMarkers() async {
    markers.add(
      Marker(
        markerId: MarkerId('0'),
        position: LatLng(31, 31),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: 'Test place',
          snippet: 'test test test',
        ),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.01, 31.01),
        /*icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          'images/bg-avatar.png',
        ),*/
        infoWindow: InfoWindow(
          title: 'Test place',
          snippet: 'test test test',
        ),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('2'),
        position: LatLng(31.02, 31.02),
        /*icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          'images/bg-avatar.png',
        ),*/
        infoWindow: InfoWindow(
          title: 'Test place',
          snippet: 'test test test',
        ),
      ),
    );
  }

  @override
  void initState() {
    setMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _defaultLocation,
              minMaxZoomPreference: const MinMaxZoomPreference(4, 100000),
              rotateGesturesEnabled: false,
              markers: markers,
            ),
          ],
        ));
  }
}
