import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> with WidgetsBindingObserver{
    @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'FAQ',
          style: GoogleFonts.getFont('Montserrat',
              color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          color: kTextoo,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Frequently",
                            style: GoogleFonts.getFont('Montserrat',
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Asked",
                            style: GoogleFonts.getFont('Montserrat',
                                color: kTextoo,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Questions",
                            style: GoogleFonts.getFont('Montserrat',
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: <Widget>[
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "APLIKASI",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselectedOpa,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Apakah saya perlu mengunduh aplikasi ini?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Di IMP STUDIO, setiap pegawai diwajibkan untuk mencatat kehadirannya sendiri. Sejalan dengan kemajuan teknologi dan kemampuan penyimpanan data kehadiran, pegawai diharapkan menggunakan aplikasi APPROVEL.",
                              style: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "ABSENSI",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselectedOpa,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Bagaimana Caranya Absensi?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Pada halaman utama (Homepage), klik tombol 'Check In', lalu pilihlah jenis absensi yang ingin Anda lakukan sesuai dengan kebutuhan. Pastikan tindakan ini dilakukan selama jam kerja.",
                              style: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 5.0),
                                  //   child: Text(
                                  //     "APLIKASI",
                                  //     style: GoogleFonts.getFont('Montserrat',
                                  //         color: kTextUnselectedOpa,
                                  //         fontSize: 10.0,
                                  //         fontWeight: FontWeight.w600),
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Apa yang harus saya lakukan saat absensi?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Untuk setiap jenis absensi, terdapat metode yang berbeda. Anda dapat memilih di antara tiga opsi: WFA (Work From Anywhere), WFO (Work From Office), dan PERJADIN. Dalam tiga pilihan ini, terdapat tiga metode pengenalan yang berbeda, yaitu pengenalan wajah (Face Recognition), lokasi geografis (Geo Location), dan sidik jari.",
                              style: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 5.0),
                                  //   child: Text(
                                  //     "APLIKASI",
                                  //     style: GoogleFonts.getFont('Montserrat',
                                  //         color: kTextUnselectedOpa,
                                  //         fontSize: 10.0,
                                  //         fontWeight: FontWeight.w600),
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Apakah ada notifikasi yang mengingatkan saya untuk melakukan absensi?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Iya, dalam aplikasi kami terdapat fitur notifikasi yang akan mengingatkan Anda untuk melakukan absensi sesuai jadwal yang telah ditentukan.",
                              style: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 5.0),
                                  //   child: Text(
                                  //     "APLIKASI",
                                  //     style: GoogleFonts.getFont('Montserrat',
                                  //         color: kTextUnselectedOpa,
                                  //         fontSize: 10.0,
                                  //         fontWeight: FontWeight.w600),
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Apakah saya bisa melihat riwayat absensi saya?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Klik ikon 📆 untuk mengakses riwayat. Anda juga memiliki opsi untuk mencari catatan absensi berdasarkan tanggal.",
                              style: GoogleFonts.getFont('Montserrat',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextBlcknw,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "KEAMANAN",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselectedOpa,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Bagaimana cara mengganti kata sandi atau mengatur keamanan akun saya?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. Buka Pengaturan: Klik ikon pengaturan ⚙️.",
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "2. Pilih Privasi: Navigasikan ke opsi privasi.",
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '3. Ubah Kata Sandi: Klik pada pilihan "Ubah Kata Sandi".',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                    ),
                    GFAccordion(
                      collapsedTitleBackgroundColor: Colors.transparent,
                      expandedTitleBackgroundColor: Colors.transparent,
                      contentBackgroundColor: Colors.transparent,
                      titleChild: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          // height: 55.0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: kTextUnselectedOpa, width: 1.0))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "KEAMANAN",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselectedOpa,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Bagaimana jika saya lupa password?",
                                      style: GoogleFonts.getFont("Montserrat",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          height: 1.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      contentChild: Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. Pergi ke halaman login.",
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '2. Klik opsi "Lupa password"',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '3. Ikuti tahapan dan arahan selanjutnya.',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextBlcknw,
                              ),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
