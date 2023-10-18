import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppbarz extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbarz({super.key});

  @override
  State<CustomAppbarz> createState() => _CustomAppbarzState();
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarzState extends State<CustomAppbarz> {
  late SharedPreferences _sharedPreferences;
  String? _name;
  String? _divisi;
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _name = _sharedPreferences.getString('nama_lengkap') ?? 'Guest';
      _divisi = _sharedPreferences.getString('divisi') ?? 'Guest';
      _avatar = _sharedPreferences.getString('avatar') ?? 'default';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_name == null || _divisi == null || _avatar == null) {
      // Display the shimmer effect here
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
        title: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.04,
                backgroundColor: Colors.grey[300],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.028,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: 80, // Adjust as needed
                    height: 14, // Adjust as needed
                  ),
                  const SizedBox(height: 5),
                  Container(
                    color: Colors.grey[300],
                    width: 60, // Adjust as needed
                    height: 10, // Adjust as needed
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.notifications_none_sharp,
                color: Color.fromRGBO(67, 129, 202, 1),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      );
    } else {
      return AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: (_avatar ?? '').isNotEmpty
                  ? Image.network(
                      'https://testing.impstudio.id/approvall/storage/files/' +
                          _avatar!,
                      height: MediaQuery.of(context).size.height * 00.5,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset('assets/img/pfp-default.jpg',
                            height: MediaQuery.of(context).size.height * 0.033,
                            fit: BoxFit.cover);
                      },
                    )
                  : Image.asset('assets/img/pfp-default.jpg',
                      height: MediaQuery.of(context).size.height * 0.033,
                      fit: BoxFit.cover),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.028,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ' + _name!,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _divisi!,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_none_sharp,
              color: Color.fromRGBO(67, 129, 202, 1),
            ),
          ),
          SizedBox(width: 10),
        ],
      );
    }
  }
}
