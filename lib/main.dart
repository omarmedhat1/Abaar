import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:water_wells_web/data/water_well_data.dart';

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
  List<WaterWellData> waterWells = [
    WaterWellData(
      name: 'water well 1',
      information: 'test information\nmore test information',
      latitude: 31,
      longitude: 31,
      thumbnailImage: CachedNetworkImage(
        imageUrl: 'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  ];
  late ClusterManager _manager;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;
  List<WaterWellData> items = [
    for (int i = 0; i < 100; i++)
      WaterWellData(
        name: 'Place $i',
        latitude: 48.848200 + i * 0.001,
        longitude: 2.319124 + i * 0.001,
        thumbnailImage: CachedNetworkImage(
          imageUrl: '',
        ),
        information: 'Place $i',
      ),
  ];
  Future<void> setMarkers() async {
    markers.add(
      Marker(
        markerId: MarkerId(waterWells[0].name),
        position: waterWells[0].getPosition(),
        onTap: () {},
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
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<WaterWellData>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: !cluster.isMultiple
              ? InfoWindow(
                  title: cluster.items.first.name,
                  snippet:
                      '${cluster.items.first.information}\nTap here to view more information!',
                )
              : const InfoWindow(),
          onTap: () async {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
            if (cluster.isMultiple) {
              var currentZoomLevel = await _googleMapController.getZoomLevel();

              currentZoomLevel = currentZoomLevel + 2;
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: cluster.location,
                    zoom: currentZoomLevel,
                  ),
                ),
              );
            }
          },
          icon: await _getMarkerBitmap(
            cluster.isMultiple ? 125 : 75,
            text: cluster.isMultiple ? cluster.count.toString() : null,
          ),
        );
      };
  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<WaterWellData>(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  @override
  void initState() {
    //setMarkers();
    _manager = _initClusterManager();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final CameraPosition _parisCameraPosition =
      const CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 12.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _parisCameraPosition,
              minMaxZoomPreference: const MinMaxZoomPreference(4, 100000),
              rotateGesturesEnabled: false,
              markers: markers,
              onTap: (position) {},
              onCameraMove: _manager.onCameraMove,
              onCameraIdle: _manager.updateMap,
              onMapCreated: (controller) {
                _googleMapController = controller;
                _controller.complete(controller);
                _manager.setMapId(controller.mapId);
              },
            ),
          ],
        ));
  }
}
