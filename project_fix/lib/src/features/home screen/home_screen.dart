import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/constant/text_string.dart';
import 'package:project_fix/src/features/home%20screen/notif/img_notif_screen.dart';
import 'package:project_fix/src/features/home%20screen/notif/msg_notif_screen.dart';
import 'package:project_fix/src/features/home%20screen/system%20information/systeminformation_screen.dart';
import 'package:project_fix/src/features/home%20screen/widget/parking_menu.dart';
import 'package:project_fix/src/features/home%20screen/widget/ride_menu.dart';
import 'package:project_fix/src/features/home%20screen/widget/scan_qr_button.dart';
import 'package:project_fix/src/features/home%20screen/widget/vehicle_unlock_menu.dart';
import 'package:project_fix/src/features/home%20screen/widget/vehicle_menu.dart';
import 'package:project_fix/src/features/my%20wallet/ride%20pass/ridepass_screen.dart';
import 'package:project_fix/src/function/notif_service.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:project_fix/src/features/about us/aboutus_screen.dart';
import 'package:project_fix/src/features/car guide/carguide_screen.dart';
import 'package:project_fix/src/features/feedback/feedback_screen.dart';
import 'package:project_fix/src/features/invite friends/invitefriends_screen.dart';
import 'package:project_fix/src/features/language switch/languageswitch_screen.dart';
import 'package:project_fix/src/features/my profile/myprofile_screen.dart';
import 'package:project_fix/src/features/my trip/mytrip_screen.dart';
import 'package:project_fix/src/features/my wallet/mywallet_screen.dart';
import 'package:project_fix/src/features/user manual/usermanual_screen.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../controllers/map_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService fs = FirestoreService();
  late WebSocketChannel channel;

  String email = '';

  String? selectedVehicle;
  bool showRideMenu = false;
  bool isParking = false;

  late GoogleMapController gmapsContoller;
  LatLng currentPosition = LatLng(-8.586705728515044, 116.09220835292544);
  LatLng? destinationPosition;
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;
  Set<Polyline> polylines = {};
  final String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";
  final MapController mapController = Get.put(MapController());
  StreamSubscription<Position>? positionStream;
  final FocusNode _searchFocusNode = FocusNode();
  bool showRouteOverlay = false;
  String destinationName = "";
  bool isDrawerOpen = false;

  // WebSocket Banner Variables
  bool showTextPopup = false;
  bool showImagePopup = false;
  String popupMsgTitle = "";
  String popupImgTitle = "";
  String popupMsgParagraph = "No additional text";
  String popupImgParagraph = "No additional text";
  String popupMessage = "No Message";
  String popupImage = "";
  int popupDuration = 3;

  void _selectVehicle(String vehicle, VehicleNumberProvider vehicleProvider) {
    setState(() {
      selectedVehicle = vehicle;
      if (vehicleProvider.isVehicleParked(vehicle)) {
        isParking = true;
        showRideMenu = false;
      } else {
        showRideMenu = true;
        isParking = false;
      }
    });
  }

  void _switchToParking() {
    setState(() {
      isParking = true;
      showRideMenu = false;
    });
  }

  void _switchToRide() {
    setState(() {
      isParking = false;
      showRideMenu = true;
    });
  }

  void _closeParkingMenu() {
    setState(() {
      isParking = false;
      selectedVehicle = null;
    });
  }

  void _closeRideMenu() {
    setState(() {
      showRideMenu = false;
      selectedVehicle = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startTrackingLocation();
    email = auth.currentUser!.email!;
    connectWebSocket();
    searchController.addListener(() {
      setState(() {}); // Memaksa UI diperbarui saat teks berubah
    });
    print("❌Loaded API Key: $googleApiKey");
  }

  @override
  void dispose() {
    searchController.removeListener(() {});
    print("❌ Disposing WebSocket Connection");
    channel.sink.close();
    positionStream?.cancel();
    super.dispose();
  }

  void connectWebSocket() {
    // IP Address Emulator
    // channel = IOWebSocketChannel.connect('ws://10.0.2.2:4000');

    // IP Address Device
    channel = IOWebSocketChannel.connect('ws://192.168.243.173:4000');

    channel.stream.listen(
      (message) {
        if (!mounted) return;
        try {
          String decodedMessage = utf8.decode((message as List<int>));

          final data = jsonDecode(decodedMessage);
          print("📩 Data Diterima dari WebSocket: $data");

          String? imageUrl = data['image'];
          String messageText = data['message'] ?? "New Message";

          NotifService().showNotification(
            title: "New Message",
            body: messageText,
            imageUrl: imageUrl,
          );

          if (data['type'] == 'text') {
            if (mounted) {
              setState(() {
                showTextPopup = data['popup'];
                popupMsgTitle = data['title'] ?? "Notification";
                popupMessage = data['message'] ?? "New Notification";
                popupMsgParagraph = data['paragraph'] ?? "No additional text";
                popupDuration = data['duration'] ?? 3;
              });
            }

            Future.delayed(Duration(seconds: popupDuration), () {
              if (mounted) {
                setState(() {
                  showTextPopup = false;
                });
              }
            });
          } else if (data['type'] == 'image') {
            if (mounted) {
              setState(() {
                showImagePopup = data['popup'];
                popupImgTitle = data['title'] ?? "Notification";
                popupImage = data['image'];
                popupImgParagraph = data['paragraph'] ?? "No additional text";
                popupDuration = data['duration'] ?? 3;
              });
            }

            Future.delayed(Duration(seconds: popupDuration), () {
              if (mounted) {
                setState(() {
                  showImagePopup = false;
                });
              }
            });
          }
        } catch (e) {
          print("❌ Error parsing JSON: $e");
        }
      },
      onError: (error) {
        print("❌ WebSocket Error: $error");
      },
      onDone: () {
        print("✅ WebSocket connection closed.");
      },
    );
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
    gmapsContoller.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition, 14),
    );
  }

  void _toggleSearchBar() {
    setState(() {
      showSearchBar = !showSearchBar;
    });
  }

  void _onPlaceSelected(Prediction place) async {
    debugPrint("Place Selected: ${place.description}");
    debugPrint("Place ID: ${place.placeId}");

    if (place.placeId == null) {
      debugPrint("Error: placeId is null!");
      return;
    }

    // Coba ambil detail lokasi dengan Place Details API
    final String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${place.placeId}&key=$googleApiKey";

    debugPrint("Fetching Place Details: $placeDetailsUrl");

    final response = await http.get(Uri.parse(placeDetailsUrl));
    final data = jsonDecode(response.body);

    if (data["status"] != "OK") {
      debugPrint("Error Fetching Details: ${data["error_message"]}");
      return;
    }

    final location = data["result"]["geometry"]["location"];
    debugPrint("Lat: ${location["lat"]}, Lng: ${location["lng"]}");

    setState(() {
      destinationPosition = LatLng(location["lat"], location["lng"]);
      _drawRoute();
    });
    _showRoutePopup(place.description ?? "Unknown Location");
  }

  void _showRoutePopup(String destinationName) {
    setState(() {
      showRouteOverlay = true;
      this.destinationName = destinationName;
    });
  }

  void _closeRoutePopup() {
    setState(() {
      showRouteOverlay = false;
      destinationPosition = null;
      polylines.clear();
    });
  }

  Future<void> _drawRoute() async {
    if (destinationPosition == null) return;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin:
            PointLatLng(currentPosition.latitude, currentPosition.longitude),
        destination: PointLatLng(
            destinationPosition!.latitude, destinationPosition!.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.status == 'OK') {
      setState(() {
        polylines = {
          Polyline(
            polylineId: PolylineId("route"),
            points: result.points
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
            color: Colors.blue,
            width: 5,
          )
        };
      });
    }
  }

  void _resetTrackingLocation() {
    if (positionStream != null) {
      positionStream!.cancel(); // Hentikan tracking lokasi
      positionStream = null;
      print("Tracking location has been reset");
    }
  }

  void _startTrackingLocation() {
    positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) {
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
      gmapsContoller.animateCamera(CameraUpdate.newLatLng(currentPosition));
      _drawRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SystemInformationScreen(),
                ),
              );
            },
          ),
        ],
        title: Text("Re:flow"),
        centerTitle: true,
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: fs.loadUser(email).then((value) => value ?? {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(
                child: Text('Error loading user data'),
              ),
            );
          } else if (!snapshot.hasData) {
            return Drawer(
              child: Center(
                child: Text('User not found'),
              ),
            );
          } else {
            var userData = snapshot.data!;
            return Drawer(
              backgroundColor: const Color.fromARGB(255, 255, 252, 252),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 30.0)),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: FileImage(
                                    File(userData['pictUrl'] ?? logoApp)),
                                radius: 30.0,
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                '${userData['fullName'] ?? null}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('My Profile'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfileScreen()));
                          },
                          trailing: Icon(Icons.chevron_right),
                        ),
                        // ListTile(
                        //   leading: Icon(Icons.luggage),
                        //   title: Text('My Trip'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => MyTripScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // Divider(),
                        // ListTile(
                        //   leading: Icon(Icons.account_balance_wallet),
                        //   title: Text('My Wallet'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => MyWalletScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.menu_book),
                        //   title: Text('User Manual'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => UserManualScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.directions_car),
                        //   title: Text('Car Guide'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => CarGuideScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.share),
                        //   title: Text('Invite Friends'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 InviteFriendsScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // Divider(),
                        // ListTile(
                        //   leading: Icon(Icons.feedback),
                        //   title: Text('Feedback'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => FeedbackScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.info),
                        //   title: Text('About Us'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => AboutUsScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.language),
                        //   title: Text('Language Switch'),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 LanguageSwitchScreen()));
                        //   },
                        //   trailing: Icon(Icons.chevron_right),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color:
                                  const Color.fromARGB(255, 255, 253, 253)!)),
                    ),
                    child: Row(
                      children: [
                        Image(
                            image: AssetImage(logoApp), width: 40, height: 40),
                        SizedBox(width: 10),
                        Text(
                          tAppName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: Consumer<VehicleNumberProvider>(
        builder: (context, vehicleProvider, child) {
          return Stack(
            children: [
              Obx(() => GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      print("❌Google Map Created");
                      gmapsContoller = controller;
                      mapController.onMapCreated(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPosition,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        position: currentPosition,
                        infoWindow: InfoWindow(title: "Your Location"),
                      ),
                      if (destinationPosition != null)
                        Marker(
                          markerId: MarkerId("destination"),
                          position: destinationPosition!,
                          infoWindow: InfoWindow(title: "Destination"),
                        ),
                      ...mapController.bikeMarkers, // Marker sepeda
                    },
                    polylines: polylines,
                  )),

              if (showRouteOverlay)
                Positioned(
                  bottom: 100,
                  left: 30,
                  right: 30,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(250, 0, 0, 0),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Text(
                            destinationName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "4.00 kilometers - 62 minutes",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close,
                                    color: Colors.grey, size: 20),
                                onPressed: _closeRoutePopup,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: 40, right: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                            ),
                            onPressed: () {
                              _closeRoutePopup();
                              _startTrackingLocation();
                            },
                            child: Text("Navigation",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (showSearchBar)
                Positioned(
                  top: kToolbarHeight,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black54),
                          onPressed: () {
                            showSearchBar = false;
                            searchController.clear();
                            _searchFocusNode.unfocus();
                            setState(() {});
                          },
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: GooglePlaceAutoCompleteTextField(
                                focusNode: _searchFocusNode,
                                textEditingController: searchController,
                                googleAPIKey: googleApiKey,
                                debounceTime: 600,
                                countries: ["ID"],
                                isLatLngRequired: true,
                                getPlaceDetailWithLatLng: _onPlaceSelected,
                                boxDecoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent)),
                                inputDecoration: InputDecoration(
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                itemBuilder: (context, index, prediction) {
                                  return SizedBox(
                                    child: Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Icon(Icons.location_on,
                                            color: Colors.red),
                                        title: Text(
                                          prediction.structuredFormatting
                                                  ?.mainText ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          prediction.structuredFormatting
                                                  ?.secondaryText ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemClick: (prediction) {
                                  searchController.text =
                                      prediction.description!;
                                  searchController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: prediction.description!.length),
                                  );
                                  _onPlaceSelected(prediction);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (vehicleProvider.lockedVehicles.isEmpty &&
                  vehicleProvider.unlockedVehicles.isEmpty &&
                  !showRideMenu &&
                  !isParking)
                // Search Button
                Obx(
                  () => Positioned(
                    bottom: () {
                      if (mapController.isBikeMarkerSelected.value) {
                        return 350.0;
                      } else if (showRouteOverlay) {
                        return 400.0;
                      } else {
                        return 150.0;
                      }
                    }(),
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: _toggleSearchBar,
                      child: Icon(
                        Icons.route_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              if (vehicleProvider.lockedVehicles.isEmpty &&
                  vehicleProvider.unlockedVehicles.isEmpty &&
                  !showRideMenu &&
                  !isParking)
                // My Location Button
                Obx(
                  () => Positioned(
                    bottom: () {
                      if (mapController.isBikeMarkerSelected.value) {
                        return 300.0;
                      } else if (showRouteOverlay) {
                        return 350.0;
                      } else {
                        return 100.0;
                      }
                    }(),
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: _getUserLocation,
                      child: Icon(
                        Icons.telegram,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              // Membership Button
              // Obx(
              //   () => Positioned(
              //     bottom: () {
              //       if (mapController.isBikeMarkerSelected.value) {
              //         return 300.0;
              //       } else if (showRouteOverlay) {
              //         return 400.0;
              //       } else {
              //         return 150.0;
              //       }
              //     }(),
              //     left: 10,
              //     child: FloatingActionButton(
              //       mini: true,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       backgroundColor: Colors.white,
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => RidePassScreen()));
              //       },
              //       child: Icon(
              //         Icons.shopping_cart_outlined,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),

              /// Popup Teks
              if (showTextPopup)
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageNotifScreen(
                            title: popupMsgTitle,
                            paragraph: popupMsgParagraph,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              popupMessage,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                showTextPopup = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              /// Popup Gambar
              if (showImagePopup)
                Positioned(
                  top: 150,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageNotifScreen(
                            paragraph: popupImgParagraph,
                            imageUrl: popupImage,
                            title: popupImgTitle,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.memory(base64Decode(popupImage)),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                showImagePopup = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (vehicleProvider.lockedVehicles.isNotEmpty &&
                  !showRideMenu &&
                  !isParking)
                VehicleUnlockMenu(
                  vehicleNumber: vehicleProvider.lockedVehicles.first,
                  onUnlock: () {
                    if (vehicleProvider.lockedVehicles.isNotEmpty) {
                      vehicleProvider
                          .unlockVehicle(vehicleProvider.lockedVehicles.first);
                    }
                    if (vehicleProvider.lockedVehicles.isEmpty) {
                      setState(() {});
                    }
                  },
                  onAnother: () {
                    if (vehicleProvider.lockedVehicles.isNotEmpty) {
                      vehicleProvider.removeLockedVehicle(
                          vehicleProvider.lockedVehicles.first);
                      setState(() {});
                    }
                  },
                  onClose: () {
                    if (vehicleProvider.lockedVehicles.isNotEmpty) {
                      vehicleProvider.removeLockedVehicle(
                          vehicleProvider.lockedVehicles.first);
                      setState(() {});
                    }
                  },
                ),
              if (!showRideMenu &&
                  !isParking &&
                  vehicleProvider.unlockedVehicles.isNotEmpty &&
                  vehicleProvider.lockedVehicles.isEmpty &&
                  vehicleProvider.isUnlocked)
                VehicleMenu(
                  onVehicleSelected: (vehicle) {
                    _selectVehicle(vehicle, vehicleProvider);
                  },
                  isParked: (selectedVehicle != null)
                      ? vehicleProvider.isVehicleParked(selectedVehicle!)
                      : false,
                ),
              if (showRideMenu && selectedVehicle != null)
                RideMenu(
                  selectedVehicle: selectedVehicle!,
                  onClose: _closeRideMenu,
                  onEndRide: () {
                    setState(() {
                      selectedVehicle = null;
                      showRideMenu = false;
                    });
                  },
                  onParkingComplete: _switchToParking,
                ),
              if (isParking && selectedVehicle != null)
                ParkingMenu(
                  selectedVehicle: selectedVehicle!,
                  onClose: _closeParkingMenu,
                  onEndRide: () {
                    setState(() {
                      selectedVehicle = null;
                      isParking = false;
                    });
                  },
                  onParkingComplete: _switchToParking,
                  onKeepRiding: () {
                    vehicleProvider.unparkVehicle(selectedVehicle ?? "");
                    _switchToRide();
                  },
                ),
              if (vehicleProvider.lockedVehicles.isEmpty &&
                  vehicleProvider.unlockedVehicles.isEmpty &&
                  !showRideMenu &&
                  !isParking)
                Obx(() => mapController.isBikeMarkerSelected.value
                    ? SizedBox.shrink() // Hide ScanQRButton
                    : ScanQRButton()),
            ],
          );
        },
      ),
    );
  }
}
