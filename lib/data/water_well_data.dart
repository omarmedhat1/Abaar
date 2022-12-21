import 'dart:js';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WaterWellData with ClusterItem {
  WaterWellData({
    required this.name,
    required this.information,
    required this.latitude,
    required this.longitude,
    required this.thumbnailImage,
    this.extraImages,
    this.video,
  });
  final String name;
  final String information;
  final double latitude;
  final double longitude;
  final String thumbnailImage;
  final List<String>? extraImages;
  final String? video;
  Marker toMarker() => Marker(
        markerId: MarkerId(name),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: name,
          snippet: information,
        ),
      );
  LatLng getPosition() => LatLng(latitude, longitude);

  @override
  LatLng get location => LatLng(latitude, longitude);

  @override
  String toString() =>
      'name: $name\nextraImages: $extraImages\n video: $video\n';
  /*Widget getCustomInfoWindowWidget() => Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "I am here",
                    )
                  ],
                ),
              ),
            ),
          ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: Colors.blue,
              width: 20.0,
              height: 10.0,
            ),
          ),
        ],
      );*/
}
