import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

class CheckoutMapWFO extends StatefulWidget {
  final Map<String, dynamic> presence;
  const CheckoutMapWFO({super.key, required this.presence});

  @override
  State<CheckoutMapWFO> createState() => CheckoutMapWFOState();
}

class CheckoutMapWFOState extends State<CheckoutMapWFO>
    with WidgetsBindingObserver {
  Position? _position;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";
  late Timer _timer;
  SharedPreferences? preferences;
  bool loading = true;
  late String nama_lengkap;
  late int user_id;
  Set<Marker> _markers = {};
  Position? lastPosition;
  bool canCheckIn = false;
  bool isWithinGeofence = false;
  bool wifiConnectedToOffice = false;

  BitmapDescriptor markerIconImp = BitmapDescriptor.defaultMarker;
  BitmapDescriptor? userIcon;

  LatLng initialLocation = const LatLng(-6.332835026352704, 106.86452087283757);
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // This will execute after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserData();
      await fetchName();
      await fetchId();

      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _updateLocationAndAddress();
      });

      connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.wifi) {
          updateCheckInStatus();
        }
      });

      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId("studio"),
            position: initialLocation,
            icon: markerIconImp,
          ),
        );
      });
    });
  }

  Future<void> fetchName() async {
    nama_lengkap = preferences?.getString('nama_lengkap') ?? 'Mahesa';
    print(nama_lengkap);
    setState(() {});
  }

  Future<void> fetchId() async {
    user_id = preferences?.getInt('user_id') ?? 2;
    print(user_id);
    setState(() {});
  }

  bool isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('hh:mm'); //"6:00"
    return format.format(dt);
  }

  Future<void> updateWfo({
    required int presenceId,
    required DateTime exitTime,
    required double latitude,
    required double longitude,
  }) async {
    var uri = Uri.parse(
        'https://admin.approval.impstudio.id/api/presence/update/$presenceId');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
      ..fields['_method'] = 'PUT'
      ..fields['exit_time'] = DateFormat('HH:mm:ss').format(exitTime)
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString();

    var response = await request.send();

    var responseData = await response.stream.bytesToString();
    print('Response Code: ${response.statusCode}');
    print('Response Data: $responseData');
    print(request.fields);

    if (response.statusCode == 200) {
      return json.decode(responseData);
    } else {
      throw Exception('Failed to update data. Response: $responseData');
    }
  }

  Future<void> _updateLocationAndAddress() async {
    Position? tempPosition = await _getCurrentLocation();
    if (tempPosition != null &&
        (lastPosition == null ||
            distanceBetween(lastPosition!, tempPosition) > threshold)) {
      lastPosition = tempPosition;
      _position = tempPosition;
      await _getAddressCoordinates();
      setState(() {
        _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: LatLng(_position!.latitude, _position!.longitude),
            icon: userIcon ??
                BitmapDescriptor.defaultMarker, // use the custom icon
            infoWindow: const InfoWindow(title: "Current Location"),
          ),
        );
      });

      updateCheckInStatus();
    }
  }

  double distanceBetween(Position position1, Position position2) {
    return Geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  final threshold = 10.0; // 10 meters

  Future<Position?> _getCurrentLocation() async {
    try {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('Service disabled');
        return null;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Permission denied');
          return null;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print('Position received: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (error) {
      print('Error getting location: $error');
      return null;
    }
  }

  Future<void> _getAddressCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position!.latitude, _position!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.street},${place.postalCode},${place.locality},${place.subLocality},${place.administrativeArea},${place.subAdministrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  double _calculateDistance() {
    if (_position == null) return double.maxFinite;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((_position!.latitude - initialLocation.latitude) * p) / 2 +
        c(initialLocation.latitude * p) *
            c(_position!.latitude * p) *
            (1 - c((_position!.longitude - initialLocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  bool _isWithinGeofence() {
    double distance = _calculateDistance();
    if (distance <= 8) {
      //BERAPA METER
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getCurrentWifiName() async {
    String? wifiName;
    try {
      wifiName = await NetworkInfo().getWifiName();
      if (wifiName != null) {
        wifiName = wifiName
            .replaceAll('"', '')
            .trim()
            .toLowerCase(); // removing the quotes
      }
    } catch (e) {
      print("Error fetching WiFi Name: $e");
    }
    print("WiFi Name: $wifiName");
    return wifiName;
  }

  Future<String?> getCurrentBSSID() async {
    String? bssid;
    try {
      bssid = await (NetworkInfo().getWifiBSSID());
    } catch (e) {
      print("Error fetching BSSID: $e");
    }
    print("BSSID: $bssid");
    return bssid;
  }

  void updateCheckInStatus() async {
    print("Executing updateCheckInStatus");

    isWithinGeofence = _isWithinGeofence();
    print("Is Within Geofence: $isWithinGeofence");

    String? wifiName = await getCurrentWifiName();
    String? wifiBSSID = await getCurrentBSSID(); // Get the BSSID

    const List<String> ACCEPTED_BSSIDS = [
      "cc:b1:82:79:c1:64",
      "cc:b1:82:79:c1:60",
    ];

    wifiConnectedToOffice = (wifiName == 'impstudio-5g' ||
        wifiName == 'impstudio-2.4g' ||
        wifiName == 'teras kolaborasi');

    if (wifiName == null || !ACCEPTED_BSSIDS.contains(wifiBSSID)) {
      setState(() {
        canCheckIn = false;
      });
      print("Can Check In: $canCheckIn");
      return;
    }

    setState(() {
      canCheckIn = isWithinGeofence && wifiConnectedToOffice;
    });

    print("Can Check In: $canCheckIn");
  }

  void addCustomIcon() async {
    markerIconImp = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 50)),
      "assets/img/marker_imp.png",
    );

    userIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 50)),
      "assets/img/user_marker.png",
    );

    setState(() {}); // to re-render
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.332835026352704, 106.86452087283757),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-6.332835026352704, 106.86452087283757),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  @override
  void dispose() {
    _timer.cancel();
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// card get location
    Widget _getlocation() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(left: 25, right: 25, top: 10)),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.white,
              color: kTextUnselected.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(
                  width: 2,
                  thickness: 2,
                  color: kButton,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Center(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/img/user_marker.png",
                        width: MediaQuery.of(context).size.width * 0.07,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${preferences?.getString('nama_lengkap')}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              )),
                          Visibility(
                            // ignore: unnecessary_null_comparison
                            visible: _currentAddress != null,
                            child: Container(
                              width: 220,
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                "$_currentAddress",
                                style: GoogleFonts.montserrat(
                                  color: greyText,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.027,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.02, // Jarak antara kontainer
          ),
          Container(
            height: MediaQuery.of(context).size.height *
                0.08, // Menggunakan persentase tinggi dari layar
            width: double.infinity,
            decoration: BoxDecoration(
              color: kTextUnselected.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(
                  width: 2,
                  thickness: 2,
                  color: kButton,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Center(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/img/marker_imp.png",
                        width: MediaQuery.of(context).size.width * 0.07,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("IMP STUDIO",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            width: 220,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Gang Mekar VII, No.11 RT 12/ RW 9, Cijantung, Kec. Pasar Rebo, Jakarta Timur, Daerah Khusus Ibukota Jakarta 13770",
                              style: GoogleFonts.montserrat(
                                color: greyText,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.027,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04, // Margin atas
                bottom:
                    MediaQuery.of(context).size.height * 0.02, // Margin bawah
              ),
              width: 250,
              height: 0.5,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              const Icon(
                LucideIcons.helpCircle,
                size: 33.0,
                color: kPrimary,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // Menggunakan lebar maksimum
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    print("Button pressed");
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      try {
                        await updateWfo(
                          presenceId: widget.presence['presence_id'],
                          exitTime: DateTime.now(),
                          latitude: _position!.latitude,
                          longitude: _position!.longitude,
                        );
                        print("checkout");

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLayout(),
                            ));
                        print("After navigating");
                      } catch (error) {
                        print("Error occurred: $error");
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButton,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Check Out Sekarang',
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget _checkoutgetlocation() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(left: 25, right: 25, top: 10)),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kTextUnselected.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(
                  width: 2,
                  thickness: 1,
                  color: kButton,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Center(
                  child: Row(
                    children: [
                      Image.asset("assets/img/marker_user.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Rumah",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            width: 220,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Jalan Sambas VII No.184, Abadijaya, Kota Depok, Jawa Barat",
                              style: GoogleFonts.montserrat(
                                color: greyText,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.027,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.02, // Jarak antara kontainer
          ),
          Container(
            height: MediaQuery.of(context).size.height *
                0.08, // Menggunakan persentase tinggi dari layar
            width: double.infinity,
            decoration: BoxDecoration(
              color: kTextUnselected.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(
                  width: 2,
                  thickness: 1,
                  color: kButton,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Center(
                  child: Row(
                    children: [
                      Image.asset("assets/img/marker_imp.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("IMP STUDIO",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            width: 220,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Gang Mekar VII, No.11 RT 12/ RW 9, Cijantung, Kec. Pasar Rebo, Jakarta Timur, Daerah Khusus Ibukota Jakarta 13770",
                              style: GoogleFonts.montserrat(
                                color: greyText,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.027,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04, // Margin atas
                bottom:
                    MediaQuery.of(context).size.height * 0.02, // Margin bawah
              ),
              width: 250,
              height: 0.5,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              const Icon(
                LucideIcons.helpCircle,
                size: 33.0,
                color: kPrimary,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // Menggunakan lebar maksimum
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButton,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Check Out',
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget _failedgetwifi() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(left: 25, right: 25)),
          Image.asset(
            "assets/gif/icon_failedwifi.gif",
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum tersambung ke WIFI Kantor',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text("Tolong sambungkan perangkat ke WIFI Kantor",
              style: GoogleFonts.montserrat(
                color: greyText,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w500,
              )),
        ],
      );
    }

    // jika gagal
    Widget _failedgetlocation() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(left: 25, right: 25)),
          Image.asset(
            "assets/gif/icon_failedloc.gif",
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Yahh, kamu gak di',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'IMP',
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: kPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' nih...',
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text("Silahkan coba lagi setelah tiba di IMP",
              style: GoogleFonts.montserrat(
                color: greyText,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w500,
              )),
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("1"),
                      position:
                          const LatLng(-6.332835026352704, 106.86452087283757),
                      icon: markerIconImp,
                    ),
                    if (userIcon != null && _position != null)
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position:
                            LatLng(_position!.latitude, _position!.longitude),
                        icon: userIcon!,
                        infoWindow: const InfoWindow(title: "Current Location"),
                      ),
                  },
                  circles: {
                    Circle(
                      circleId: const CircleId("1"),
                      center: initialLocation,
                      radius: 8, //RADIUS PER METER
                      strokeColor: kPrimary,
                      strokeWidth: 2,
                      fillColor: const Color(0xFF006491).withOpacity(0.2),
                    ),
                  },
                ),
                Positioned(
                  top: 16,
                  left: 12,
                  width: 48,
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.pop(
                        context,
                        
                      );
                      _timer.cancel();
                    },
                    backgroundColor: const Color(0xff4381CA).withOpacity(0.45),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 12,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xff4381CA),
                    onPressed: _goToTheLake,
                    child: Image.asset(
                      "assets/img/imp-logoo.png",
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 72, // Adjust this value as per your layout needs
                  left: 12,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _zoomToCurrentLocation,
                    child: const Icon(Icons.my_location, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 30, top: 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  padding: const EdgeInsets.only(right: 25, left: 25),
                  width: double.infinity,
                  color: Colors.white,
                  child: canCheckIn
                      ? _getlocation()
                      : (!isWithinGeofence
                          ? _failedgetlocation()
                          : _failedgetwifi())),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _zoomToCurrentLocation() async {
    if (_position != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_position!.latitude, _position!.longitude),
          zoom: 25.0, // Adjust the zoom level as needed
        ),
      ));
    } else {
      print("Location not available");
    }
  }
}
