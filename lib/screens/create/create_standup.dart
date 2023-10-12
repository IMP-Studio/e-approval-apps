import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/screens/create/create_detail_standup.dart';
import 'package:imp_approval/screens/detail/detail_daftarproject_beforestandup.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';


class CreateStandup extends StatefulWidget {
  const CreateStandup({super.key});

  @override
  State<CreateStandup> createState() => _CreateStandupState();
}

class _CreateStandupState extends State<CreateStandup>
    with WidgetsBindingObserver {
  SharedPreferences? preferences;

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    

    getUserData().then((_) {
      _dataFuture = getProject();
    });

  
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

  String _searchQuery = "";
  List<dynamic>? _filteredProjects;
  Future? _dataFuture;

  Future getProject() async {
    final String urlj = 'https://testing.impstudio.id/approvall/api/project';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

    int computeDaysLeft(String endDate) {
    DateTime end = DateTime.parse(endDate);
    DateTime current = DateTime.now();
    return end.difference(current).inDays;
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + ' ...';
    }
  }

  @override
  final double _tinggidesc = 68;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.chevronLeft,
                      color: kButton,
                    ),
                    Text(
                      'Kembali',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: kButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.briefcase,
                  color: Color.fromRGBO(67, 129, 202, 1),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // HERO
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.35,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kTextoo, kTextoo])),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.007,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Project",
                                  style: GoogleFonts.getFont('Montserrat',
                                      textStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.055,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "Buat rencana project mu dengan metode Done, Doing, Blocker",
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.028,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SvgPicture.asset(
                          "assets/img/hero-image-standup.svg",
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.3,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),

                // FORM CREATE

                const SizedBox(
                  height: 5,
                ),

                // NAMA PROJECT

                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          // height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: Offset(0, 1)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Cari Project...",
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.montserrat(
                                          color: kTextBlcknw,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.034),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                  size: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FutureBuilder(
                          future: _dataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('An error occurred!'));
                            }

                            if (!snapshot.hasData) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                itemBuilder: (context, index) {
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 2),
                                          color: Colors.grey[300],
                                        ),
                                        padding: const EdgeInsets.only(
                                            right: 15,
                                            left: 15,
                                            top: 10,
                                            bottom: 10),
                                        height: _tinggidesc,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            var projects = snapshot.data['data'] as List;


                            // Filtering the projects based on the search query.
                            if (_searchQuery.isNotEmpty) {
                              projects = projects.where((project) {
                                return project['project']
                                    .toString()
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase());
                              }).toList();
                            }

                            if (projects.isEmpty) {
                              return Center(child: Text("No projects found."));
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: projects.length,
                                itemBuilder: (context, index) {
                                                              var project = projects[index];
                                  int daysLeft = computeDaysLeft(project['end_date']);
                                  print(project);
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailDaftarProject(
                                                    project: project,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            padding:
                                                EdgeInsets.only(left: 20.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 0,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            height: _tinggidesc,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.start,
                                                      children: [
                                                        Text(
                                                          truncateText(
                                                              project[
                                                                  'project'],
                                                              20),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        // Add more widgets as needed
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                 '$daysLeft hari lagi' ,
                                                  style: GoogleFonts.getFont(
                                                      'Montserrat',
                                                      color: kTextBlcknw,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.028,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Positioned(
                                        right: -1,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0)),
                                            child:
                                            project['status'] == 'Aktif'
                                                ? SvgPicture.asset(
                                              "assets/img/aktif.svg",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.19,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              fit: BoxFit.cover,
                                            )

                                                : SvgPicture.asset(
                                              "assets/img/nonaktif.svg",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.19,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              fit: BoxFit.cover,
                                            ),
                                             
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
