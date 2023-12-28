import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/detail/detail_infopribadi.dart';
import 'package:imp_approval/screens/detail/detail_privasi.dart';
import 'package:imp_approval/screens/detail/detail_faq.dart';
import 'package:imp_approval/screens/detail/detail_infoapp.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imp_approval/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  SharedPreferences? preferences;

  late Timer _timer; // Define the timer
  bool _isMounted = false;
  bool _isSnackbarVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMounted = true;
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _isMounted = false;
    super.dispose();
  }

  void showSnackbarWarning(String message, String submessage,
      Color backgroundColor, Icon customIcon) {
    if (_isSnackbarVisible) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    _isSnackbarVisible = true;

    int secondsRemaining = 3; // Set the initial duration to 10 seconds
    _timer.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isMounted) {
        timer.cancel();
        return;
      }

      if (secondsRemaining == 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _isSnackbarVisible = false;
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
    final snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.8),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [customIcon],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    message,
                                    style: GoogleFonts.getFont('Montserrat',
                                        textStyle: TextStyle(
                                            color: kBlck,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034,
                                            fontWeight: FontWeight.w600)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  )),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                              ),
                              Text(
                                submessage,
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 5,
                height: 49,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer = Timer(Duration.zero, () {});
    getUserData().then((_) {
      print(preferences?.getInt('user_id'));
    });
  }

  Future<void> refreshUserData() async {
    await getUserData();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _validpassController = TextEditingController();
    bool validasilogout = true;

    Future<void> logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      var response = await http.post(
        Uri.parse('https://admin.approval.impstudio.id/api/logout'),
        body: {
          "validpassword": _validpassController.text,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        preferences.remove('token');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        // ignore: unused_local_variable
        final snackBar = showSnackbarWarning(
            "Logout gagal",
            "Password salah.",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
      }
    }

    Widget _modalvalidasilogout(BuildContext context) {
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
              onPressed: () {
                if (validasilogout) {
                  logout();
                  setState(() {
                    validasilogout = false;
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
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
                'Masukkan password saat ini untuk konfirmasi diri anda sebelum Logout.',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _validpassController,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Menghilangkan background color
        title: Text(
          'Settings',
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
          child: RefreshIndicator(
        onRefresh: refreshUserData,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        // card profile \\
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: (preferences?.getString('avatar') ?? '')
                                      .isNotEmpty
                                  ? Image.network(
                                      'https://admin.approval.impstudio.id/storage/' +
                                          preferences!.getString('avatar')!,
                                      height: 58,
                                      width: 58,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                            'assets/img/pfp-default.jpg',
                                            height: 58,
                                            width: 58,
                                            fit: BoxFit.cover);
                                      },
                                    )
                                  : Image.asset('assets/img/pfp-default.jpg',
                                      height: 58, width: 58, fit: BoxFit.cover),
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20), // Add vertical padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${preferences?.getString('nama_lengkap')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${preferences?.getString('posisi')}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // list menu setting \\
                  Column(
                    children: [
                      // informasi pribadi
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InformasiPribadi(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.user,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Informasi Pribadi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // informasi notifikasi
                      InkWell(
                        onTap: () {
                          // Tambahkan aksi yang ingin Anda lakukan ketika widget ditekan
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.bell,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Notifikasi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // informasi privasi
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivasiPage(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.shield,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Privasi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // informasi aplikasi
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InfoApp(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.info,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Informasi Aplikasi',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Faq
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FaqScreen(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.helpCircle,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('FAQ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // keluar
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (validasilogout)
                                    _modalvalidasilogout(context),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.logOut,
                                      color: kTextgrey,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Keluar',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: kTextgrey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      color: kBorder,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
