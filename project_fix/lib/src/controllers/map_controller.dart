import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:project_fix/src/widgets/bike_info_bottomsheet.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> googleMapController = Completer();
  var bikeMarkers = <Marker>{}.obs;

  var isBikeMarkerSelected = false.obs;

  static const LatLng initialLocation = LatLng(-8.585450, 116.092708);

  @override
  void onInit() {
    super.onInit();
    _loadBikeMarkers(Get.context);
  }

  void onMapCreated(GoogleMapController controller) {
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
    }
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks.isNotEmpty
          ? placemarks[0].name ?? "Lokasi tidak ditemukan"
          : "Lokasi tidak ditemukan";
    } catch (e) {
      return "Error mendapatkan lokasi";
    }
  }

  Future<BitmapDescriptor> _createBikeMarker(int batteryLevel) async {
    return await Container(
      padding: EdgeInsets.all(8),
      color: const Color.fromARGB(0, 163, 43, 43),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: _TriangleClipper(),
                child: Container(
                  // margin: EdgeInsets.only(top: 50),
                  margin: EdgeInsets.only(top: 40),
                  width: 90,
                  height: 8,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  value: batteryLevel / 100,
                  strokeWidth: 5,
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 41, 168, 214)),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: Icon(
                  Icons.pedal_bike,
                  size: 20,
                  color: const Color.fromARGB(255, 41, 168, 214),
                ),
              ),
            ],
          ),
        ],
      ),
    ).toBitmapDescriptor();
  }

  void _loadBikeMarkers(BuildContext? context) async {
    if (context == null) {
      print("Error: BuildContext is null!");
      return;
    }
    final List<Map<String, dynamic>> dummyBikeLocations = [
      {
        "id": "24D043",
        "position": LatLng(-8.585629, 116.092477),
        "battery": 75,
        "time": 10,
        "distance": 1.2,
      },
      {
        "id": "24S150",
        "position": LatLng(-8.585789, 116.091726),
        "battery": 40,
        "time": 5,
        "distance": 0.7,
      },
    ];

    Set<Marker> markers = {};

    for (var bike in dummyBikeLocations) {
      BitmapDescriptor customIcon = await _createBikeMarker(bike["battery"]);

      markers.add(Marker(
        markerId: MarkerId(bike["id"]),
        position: bike["position"],
        icon: customIcon,
        onTap: () {
          // Debug log untuk melihat data yang dikirim
          print(
              "Tapping marker: ID - ${bike["id"]}, Battery - ${bike["battery"]}, Position - ${bike["position"]}, Time - ${bike["time"]}, Distance - ${bike["distance"]}");

          isBikeMarkerSelected.value = true;

          // Pastikan data tidak null sebelum memanggil bottom sheet
          if (bike["id"] != null && bike["battery"] != null) {
            getAddressFromLatLng(bike["position"]).then((location) {
              BikeInfoPopup.show(
                context,
                bike["id"] as String,
                bike["distance"],
                bike["time"],
                bike["battery"],
                location,
                onClose: () {
                  isBikeMarkerSelected.value = false;
                },
              );
            });
          } else {
            print("Error: Bike ID or Battery is null");
          }
        },
      ));
    }

    bikeMarkers.assignAll(markers);
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
