import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SyaratCutiKhusus extends StatefulWidget {
  const SyaratCutiKhusus({super.key});

  @override
  State<SyaratCutiKhusus> createState() => _SyaratCutiKhususState();
}

class _SyaratCutiKhususState extends State<SyaratCutiKhusus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Menikah",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "3",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Menikahkan anaknya",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "2",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Mengkhitankan anaknya",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "2",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Membaptiskan anaknya",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "2",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Istri melahirkan",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "2",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Melahirkan",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "90",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Kegurguan",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "45",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Melakukan ibadah haji",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "40",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 0.5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Umroh",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextBlcknw,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "10",
                                  style: GoogleFonts.getFont('Montserrat',
                                      color: kBlck,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }
}
