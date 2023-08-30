import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class DetailRequestWfa extends StatefulWidget {
  const DetailRequestWfa({super.key});

  @override
  State<DetailRequestWfa> createState() => _DetailRequestWfaState();
}

Widget _modalvalidasireject(BuildContext context) {
  return CupertinoAlertDialog(
    title: Text("Alasan Menolak",
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
    actions: [
      CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Batal",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: kTextBlocker,
                fontWeight: FontWeight.w600,
              ))),
      CupertinoDialogAction(
          onPressed: () {},
          child: Text("Kirim",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ))),
    ],
    content: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.010,
        ),
        CupertinoTextField(
          padding: EdgeInsets.symmetric(vertical: 20),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          placeholder: 'ketikan sesuatu....',
          placeholderStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: kTextgrey,
            fontWeight: FontWeight.w500,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

class _DetailRequestWfaState extends State<DetailRequestWfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  Icon(
                    LucideIcons.chevronLeft,
                    size: MediaQuery.of(context).size.width * 0.050,
                    color: kButton,
                  ),
                  Text(
                    'Kembali',
                    style: GoogleFonts.montserrat(
                      fontSize: MediaQuery.of(context).size.width * 0.0345,
                      fontWeight: FontWeight.w400,
                      color: kTextoo,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.userCheck,
                size: MediaQuery.of(context).size.width * 0.06,
                color: kTextoo,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Request',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Employee',
                      style: GoogleFonts.montserrat(
                        color: kTextoo,
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  width: 70,
                  height: 2,
                  color: kTextoo,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: kBorder, width: 1),
                    top: BorderSide(color: kBorder, width: 1),
                  )),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.05,
                        backgroundImage: AssetImage(
                          "assets/img/profil2.png",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.028,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fauzan Alghifari',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Backend Developer',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: greyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '08.43 AM',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '“',
                          style: GoogleFonts.montserrat(
                            color: kPrimary,
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Sebagai karyawan, saya mengajukan permohonan untuk bekerja dari tempat lain karena kondisi kesehatan yang sedang saya hadapi. Sayangnya, penyakit yang saya alami saat ini membuat saya sulit untuk hadir di kantor secara fisik. Meskipun demikian, saya ingin menekankan bahwa komitmen saya terhadap pekerjaan dan tim tetap kuat.',
                          style: GoogleFonts.montserrat(
                            color: greyText,
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                          ),
                        ),
                        TextSpan(
                          text: '”',
                          style: GoogleFonts.montserrat(
                            color: kPrimary,
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.028,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Work From Anywhere',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.039,
                            color: kTextoo,
                            fontWeight: FontWeight.w600,
                          )),
                      Text('TYPE : Kesehatan',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.028,
                            color: kTextgrey,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kTextBlocker,
                                side: const BorderSide(
                                  color: kTextBlocker,
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _modalvalidasireject(context);
                                  },
                                );
                              },
                              child: const Text("Reject"),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kButton,
                                side: const BorderSide(
                                  color: kButton,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Approve"),
                            ),
                          ],
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
    );
  }
}
