import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';

class InfoApp extends StatefulWidget {
  const InfoApp({super.key});

  @override
  State<InfoApp> createState() => _InfoAppState();
}

class _InfoAppState extends State<InfoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: EdgeInsets.only(top: 50.0),
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/InformasiAplikasi.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "APPROVEL",
                style: GoogleFonts.getFont('Montserrat',
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "Version 1.0.0",
                style: GoogleFonts.getFont('Montserrat',
                    fontSize: 12.0,
                    color: kTextUnselected,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                height: 120.0,
                width: 120.0,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/img/logo.png'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
