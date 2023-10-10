import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DetailSyaratCutiKhusus extends StatefulWidget {
  const DetailSyaratCutiKhusus({super.key});

  @override
  State<DetailSyaratCutiKhusus> createState() => _DetailSyaratCutiKhususState();
}

class _DetailSyaratCutiKhususState extends State<DetailSyaratCutiKhusus> {
  void initState() {
    super.initState();
    getKhusus();
  }

  Future getKhusus() async {
    String baseURL =
        'https://testing.impstudio.id/approvall/api/leave/option?type=2';

    var response = await http.get(Uri.parse(baseURL));
    print(response.body);
    print(baseURL);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  LucideIcons.chevronLeft,
                  color: kButton,
                ),
              ),
              Text(
                'Kembali',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: kButton,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.award,
                  color: Color.fromRGBO(67, 129, 202, 1),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: SafeArea(
            child: ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Divider(
                            color: Color.fromRGBO(67, 129, 202, 1),
                            thickness: 2,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Syarat &",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Ketentuan",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: const Color.fromRGBO(67, 129, 202, 1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            "Cuti Khusus",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ketentuan",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextoo,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Text(
                                "Hari",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextoo,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FutureBuilder(
                          future: getKhusus(),
                          builder: (context, snapshot) {
                            // Check for errors first.
                            if (snapshot.hasError) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 15, // number of mock items
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: kTextUnselectedOpa,
                                              width: 0.5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (160 / 320),
                                            color: Colors.grey[
                                                300], // placeholder color for the text
                                            height:
                                                20, // giving it a height to simulate a line of text
                                          ),
                                          Spacer(),
                                          Container(
                                            color: Colors
                                                .grey[300], // placeholder color
                                            width:
                                                20, // width for the mock number
                                            height:
                                                20, // height for the mock number
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            // Check the connection state.
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 15, // number of mock items
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: kTextUnselectedOpa,
                                              width: 0.5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (160 / 320),
                                            color: Colors.grey[
                                                300], // placeholder color for the text
                                            height:
                                                20, // giving it a height to simulate a line of text
                                          ),
                                          Spacer(),
                                          Container(
                                            color: Colors
                                                .grey[300], // placeholder color
                                            width:
                                                20, // width for the mock number
                                            height:
                                                20, // height for the mock number
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            if (snapshot.data?['data'] == null ||
                                snapshot.data['data'].isEmpty) {
                              return Center(
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            }

                            var limitedData = snapshot.data['data'].toList();
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: limitedData.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: kTextUnselectedOpa,
                                              width: 0.5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (160 / 320),
                                        child: Text(
                                          limitedData[index]
                                              ['description_leave'],
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kTextBlcknw,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          limitedData[index]['days'].toString(),
                                          style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: kBlck,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.028,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }
}
