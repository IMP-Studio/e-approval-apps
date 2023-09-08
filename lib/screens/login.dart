import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/layout/mainlayout.dart';
import 'package:imp_approval/methods/api.dart';
import 'package:imp_approval/screens/changePasswordOtp/forgetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _positionAnimation;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void loginUser() async {
    final data = {
      'email': email.text.toString(),
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/loginApi', data: data);

    print(result.body);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('user_id', response['user']['id']);
      await preferences.setString('name', response['user']['name']);
      await preferences.setString(
          'nama_lengkap', response['user']['nama_lengkap']);
      await preferences.setString('divisi', response['user']['divisi']);
      await preferences.setString('status', response['user']['status']);
      await preferences.setString('email', response['user']['email']);
      await preferences.setString('role', response['user']['role']);
      await preferences.setString('token', response['token']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainLayout(),
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Animation duration
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _positionAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(); // Start the animation when the widget is initialized
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff246DC1),
              const Color(0xff246DC1).withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Menengahkan vertikal
          children: [
            Expanded(
              child: SlideTransition(
                position: _positionAnimation,
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 300,
                    child: Image.asset('assets/img/imp-logo.png'),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: SlideTransition(
                position: _positionAnimation,
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(right: 30, left: 30, bottom: 10),
                        decoration: const BoxDecoration(
                          color: kBackground,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(35.0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 55,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Welcome to ',
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.067,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Approvel!',
                                          style: GoogleFonts.montserrat(
                                            color: kTextoo,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.067,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Masuk ',
                                          style: GoogleFonts.montserrat(
                                            color: kTextoo,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'menggunakan akun mu!',
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('E-mail',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.034,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),

                            TextFormField(
                              controller: email,
                              style: GoogleFonts.montserrat(
                                color: kText,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                fontWeight: FontWeight.w400,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter Your Email',
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.028,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: const Align(
                                  widthFactor: 3,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: kIcon,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: kInput,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.024),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Password',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.034,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),

                            TextFormField(
                              controller: password,
                              obscureText: true,
                              style: GoogleFonts.montserrat(
                                color: kText,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.039,
                                fontWeight: FontWeight.w400,
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.028,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                prefixIcon: const Align(
                                  widthFactor: 3,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.lock,
                                    color: kIcon,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: kInput,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ForgetPassword(),
                                          ),
                                        );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text("Lupa password ?",
                                        style: GoogleFonts.montserrat(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.034,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            InkWell(
                              onTap: () {
                                loginUser();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: kButton,
                                ),
                                child: Center(
                                  child: Text(
                                    "Login to Approvel",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.039,
                                      fontWeight: FontWeight.w700,
                                      color: kBackground,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
