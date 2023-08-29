import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  LatLng initialLocation = const LatLng(-6.332835026352704, 106.86452087283757);

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      "assets/img/marker_imp.png",
    ).then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-6.332835026352704, 106.86452087283757),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  @override
  Widget build(BuildContext context) {
// card get location
    Widget _getlocation() {
      return Column(
        children: [
          Padding(padding: EdgeInsets.only(left: 25, right: 25, top: 10)),
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
                VerticalDivider(
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
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            width: 220,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Jalan Sambas VII No.184, Abadijaya, Kota Depok, Jawa Barat",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
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
                VerticalDivider(
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
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            width: 220,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Gang Mekar VII, No.11 RT 12/ RW 9, Cijantung, Kec. Pasar Rebo, Jakarta Timur, Daerah Khusus Ibukota Jakarta 13770",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
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
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Icon(
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
                    'Check In Sekarang',
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget _failedgetlocation() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 25, right: 25)),
          Image.asset(
            "assets/img/icon_failedloc.png",
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'IMP',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: kPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' nih...',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text("Silahkan coba lagi setelah tiba di IMP",
              style: GoogleFonts.montserrat(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w500,
              )),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04, // Margin atas
              bottom: MediaQuery.of(context).size.height * 0.02, // Margin bawah
            ),
            width: 250,
            height: 0.5,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width *
                0.7, // Menggunakan lebar maksimum
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                  Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kButton,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back',
              ),
            ),
          )
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
                      position: LatLng(-6.332835026352704, 106.86452087283757),
                      icon: markerIcon,
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: CircleId("1"),
                      center: initialLocation,
                      radius: 40,
                      strokeWidth: 2,
                      fillColor: Color(0xFF006491).withOpacity(0.2),
                    ),
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: FloatingActionButton(
                    onPressed: _goToTheLake,
                    child: Icon(Icons.home),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.only(right: 25, left: 25),
                width: double.infinity,
                height: 280,
                color: Colors.white,
                child: _getlocation(),
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: _goToTheLake,
      //       child: Icon(Icons.home),
      //     ),
      //     SizedBox(height: 16), // Atur jarak antara tombol-tombol
      //     FloatingActionButton(
      //       onPressed: () {
      //         _openBottomSheet();
      //       },
      //       child: Icon(LucideIcons.calendarPlus),
      //     ),
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
