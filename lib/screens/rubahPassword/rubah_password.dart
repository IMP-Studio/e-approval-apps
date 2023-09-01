import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RubahPassword extends StatefulWidget {
  const RubahPassword({super.key});

  @override
  State<RubahPassword> createState() => _RubahPasswordState();
}

class _RubahPasswordState extends State<RubahPassword> {
  bool _isPasswordVisible = false;

  bool _konfirPasswordVisible = false;

  Widget _modalvalidasipass(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Validasi Password",
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
          Text(
              'Masukkan password saat ini untuk konfirmasi sebelum mengubah password baru.',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              )),
          SizedBox(height: 10),
          CupertinoTextField(
            obscureText: true, // Gunakan status _isPasswordVisible
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            placeholder: 'Masukan password',
            placeholderStyle: GoogleFonts.montserrat(
              fontSize: 14,
              color: kTextgrey,
              fontWeight: FontWeight.w500,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyText, width: 0.5),
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground3,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: kButton,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(LucideIcons.chevronLeft),
        ),
        title: Text(
          'Privasi',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              // password
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        'Password',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: kTextgrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              obscureText:
                                  !_isPasswordVisible, // Gunakan status _isPasswordVisible
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Masukkan password baru',
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                // Diperlukan jika ini berada dalam StatefulWidget
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Ubah status ketika ikon diklik
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // konfirmasi password
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        'Konfirmasi password',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: kTextgrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              obscureText: !_konfirPasswordVisible,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Konfirmasi password',
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _konfirPasswordVisible =
                                    !_konfirPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _konfirPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kBorder,
                              shadows: [
                                Shadow(color: Colors.transparent),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      foregroundColor: Colors.black,
                      side: const BorderSide(
                        width: 1,
                        color: kBorder,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _modalvalidasipass(context);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: kButton,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Konfirmasi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
