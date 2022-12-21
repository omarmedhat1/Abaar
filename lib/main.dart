import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:water_wells_web/data/water_well_data.dart';
import 'package:water_wells_web/view_water_well/view_water_well_widget.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterFlowTheme.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  @override
  void initState() {
    super.initState();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('ar'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      /*routes: {
        'water-well-page': (context) => const ViewWaterWellWidget(),
      },*/
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
      thumbnailImage: 'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
      extraImages: [
        'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
        'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
        'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
        'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
        'https://www.care.org.tr/files/2017/04/img_0225-jpg.jpg',
      ],
      video: 'https://www.youtube.com/watch?v=h1PAH0RRX1o',
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
        thumbnailImage:
            'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
        information: 'Place $i\nTest Test Test',
        extraImages: [
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
          'https://images.squarespace-cdn.com/content/v1/577d6ce41b631b591bf11b0c/1615934188360-VX3N91NWZQ89S6SX5BCB/bb.2018-02-17.01-47-08+copy+2.png',
        ],
        video: 'https://www.youtube.com/watch?v=h1PAH0RRX1o',
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
                  snippet: 'إضغط لإظهار معلوملت اكثر',
                  onTap: () {
                    print(cluster.items.first.toString());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewWaterWellWidget(
                          name: cluster.items.first.name,
                          information: cluster.items.first.information,
                          latitude: cluster.items.first.latitude,
                          longitude: cluster.items.first.longitude,
                          thumbnail: cluster.items.first.thumbnailImage,
                          extraImages: cluster.items.first.extraImages,
                          video: cluster.items.first.video,
                        ),
                      ),
                    );
                  },
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
    final Paint paint1 = Paint()..color = Colors.blueAccent;
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
            Positioned(
              bottom: MediaQuery.of(context).size.height / 5,
              right: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black54,
                ),
                child: MaterialButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      countryListTheme: CountryListThemeData(
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height / 2,
                      ),
                      onSelect: (Country country) {
                        print('Select country: ${country.countryCode}');
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      Text(
                        'بحث',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
