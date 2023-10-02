import 'package:flutter/material.dart';
import 'package:imp_approval/screens/edit/edit_perjadin.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPerjadin extends StatefulWidget {
  final dynamic absen;
  DetailPerjadin({required this.absen});

  @override
  State<DetailPerjadin> createState() => _DetailPerjadinState();
}

String truncateFileName(String fileName, int maxLength) {
  if (fileName.length <= maxLength) {
    return fileName;
  } else {
    final extensionIndex = fileName.lastIndexOf('.');
    final name = fileName.substring(0, extensionIndex);
    final extension = fileName.substring(extensionIndex);

    final truncatedName = name.substring(0, maxLength - 3);
    return truncatedName + '... ' + extension;
  }
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
          padding: const EdgeInsets.symmetric(vertical: 20),
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

class _DetailPerjadinState extends State<DetailPerjadin>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<File?> downloadFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final downloadsDirectory = Directory('/storage/emulated/0/Download');

        // Ensure the directory exists
        if (!await downloadsDirectory.exists()) {
          await downloadsDirectory.create(recursive: true);
        }

        final file = File('${downloadsDirectory.path}/$filename');
        print(
            "Attempting to save file to: ${file.path}"); // This will print out the exact path where the file is being saved

        // Before writing to the file, let's check if the directory exists.
        final parentDir = file.parent;
        if (!await parentDir.exists()) {
          await parentDir.create(
              recursive: true); // Ensuring the directory structure exists.
        }

        return file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return null;
  }

  Future<void> onDownloadButtonPressed() async {
    final filess = widget.absen['file'].toString();
    final url = 'https://testing.impstudio.id/approvall/storage/$filess';

    if (filess.toLowerCase().endsWith(".pdf")) {
      // Handle PDF files by downloading and then displaying
      final downloadedFile = await downloadFile(url, filess);

      if (downloadedFile != null && downloadedFile.existsSync()) {
        print("File path: ${downloadedFile.path}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PDFViewerScreen(filePath: downloadedFile.path),
          ),
        );
      } else {
        print(
            "Failed to fetch PDF file or file does not exist at expected path");
        if (downloadedFile != null) {
          print("Expected file path: ${downloadedFile.path}");
        }
      }
    }
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return "${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  String formatDateRange(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    String formattedStartDay = DateFormat('d').format(start);
    String formattedEndDay = DateFormat('d').format(end);
    String formattedMonth =
        DateFormat('MMMM').format(start); // e.g., "November"
    String formattedYear = DateFormat('y').format(start); // e.g., "2023"

    return '$formattedStartDay-$formattedEndDay $formattedMonth $formattedYear';
  }

  Widget _category(BuildContext context) {
    if (widget.absen['category'] == 'work_trip') {
      return Text('Perjalanan Dinas',
          style: GoogleFonts.montserrat(
            fontSize: MediaQuery.of(context).size.width * 0.040,
            color: blueText,
            fontWeight: FontWeight.w600,
          ));
    } else {
      return const Text('Unknown category');
    }
  }

  Future editPresence() async {
    String url = 'https://testing.impstudio.id/approvall/api/presence/get/' +
        widget.absen['id'].toString();
    var response = await http.get(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
  }

  Future destroyPresence() async {
    String url = 'https://testing.impstudio.id/approvall/api/presence/delete/' +
        widget.absen['id'].toString();
    var response = await http.delete(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
  }

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return '-- : --';
    }

    try {
      List<String> parts = dateTimeStr.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) hour -= 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '-- : --';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getStatusRow(String status) {
      Color containerColor;
      Color textColor;
      String text;

      switch (status) {
        case 'rejected':
          containerColor = const Color(0xffF9DCDC);
          textColor = const Color(
              0xffCA4343); // Or any color that matches well with red.
          text = 'Rejected';
          break;
        case 'pending':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(
              0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'allow_HT':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(
              0xffFFC52D); // Black usually matches well with yellow.
          text = 'Pending';
          break;
        case 'allowed':
          containerColor = kGreenAllow; // Assuming kGreenAllow is green
          textColor = kGreen; // Your green color for text
          text = 'Allowed';
          break;
        default:
          containerColor = Colors.grey;
          textColor = Colors.white;
          text = 'Unknown Status';
      }

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.16,
            decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: textColor),
                color: containerColor,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.030)),
            child: Text(
              text,
              style: GoogleFonts.getFont("Montserrat",
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: textColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    String currentStatus = widget.absen['status'];

    Widget statusWidget = getStatusRow(currentStatus);

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
                    color: kButton,
                    size: MediaQuery.of(context).size.width * 0.050,
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
            const Spacer(),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Detail ',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.070,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Attendance',
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
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: kBorder, width: 1),
                    top: BorderSide(color: kBorder, width: 1),
                  )),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.05,
                        backgroundImage: const AssetImage(
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
                            widget.absen['nama_lengkap'],
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.absen['posisi'],
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              color: greyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      getStatusRow(currentStatus)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.028,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Perjalan Dinas',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.044,
                            color: kTextoo,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                              'Tanggal : ' +
                                  formatDateRange(widget.absen['start_date'],
                                      widget.absen['end_date']),
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.028,
                                color: greyText,
                                fontWeight: FontWeight.w500,
                              )),
                          const Spacer(),
                          Text(
                              'Masuk : ' +
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.parse(
                                              widget.absen['entry_date']) ??
                                          DateTime.now()),
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.028,
                                color: greyText,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.030,
                  ),
                  // pdf/img/word
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: kBorder.withOpacity(0.5)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 1, 50),
                    ),
                    onPressed: onDownloadButtonPressed,
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Icon(
                          LucideIcons.fileText,
                          size: 24.0,
                          color: kBorder.withOpacity(0.5),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                truncateFileName(
                                    widget.absen['file'],
                                    (MediaQuery.of(context).size.width * 0.1)
                                        .toInt()),
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // This is a placeholder. You'd replace "1.2MB" with the actual file size using formatBytes function once you have it.
                              Text(
                                "1.2MB",
                                style: GoogleFonts.montserrat(
                                  fontSize: 6,
                                  color: kTextgrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.02,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.absen['status'] == 'pending',
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: kTextBlocker,
                                  side: const BorderSide(
                                    color: kTextBlocker,
                                  ),
                                ),
                                onPressed: () {
                                  destroyPresence().then((value) {
                                    setState(() {
                                      Navigator.pop(context, 'refresh');
                                    });
                                    // scaffold an asli nanti gua coba0
                                  });
                                },
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Visibility(
                              visible: widget.absen['status'] == 'pending',
                              child: FutureBuilder(
                                future: editPresence(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Shimmer.fromColors(
                                        baseColor: kButton.withOpacity(0.8)!,
                                        highlightColor:
                                            kButton.withOpacity(0.5)!,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                kButton.withOpacity(0.8),
                                            side: BorderSide(
                                              color: kButton.withOpacity(0.8)!,
                                            ),
                                          ),
                                          onPressed:
                                              null, // disables the button
                                          child: const Text("Edit"),
                                        ),
                                      );
                                    } else {
                                      return OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: kButton,
                                          side: const BorderSide(
                                            color: kButton,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPerjadin(
                                                      absen: snapshot
                                                          .data['data']),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Edit",
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: kButton.withOpacity(0.8)!,
                                      highlightColor: kButton.withOpacity(0.5)!,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              kButton.withOpacity(0.8),
                                          side: BorderSide(
                                            color: kButton.withOpacity(0.8)!,
                                          ),
                                        ),
                                        onPressed: null, // disables the button
                                        child: const Text("Edit"),
                                      ),
                                    );
                                  }
                                },
                              ),
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

class PDFViewerScreen extends StatefulWidget {
  final String filePath;

  PDFViewerScreen({required this.filePath});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PDFViewController _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    // Extracting the filename from the full file path
    String fileName = widget.filePath.split('/').last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003366),
        title: Text(
          fileName, // Display the name of the file here
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.filePath,
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
            },
            onPageChanged: (int? page, int? totalPages) {
              if (page != null && totalPages != null) {
                if (_totalPages == 0) {
                  _totalPages = totalPages;
                }
                setState(() {
                  _currentPage = page + 1; // PDF's page index starts from 0
                });
              }
            },
            onRender: (pages) {
              if (pages != null) {
                setState(() {
                  _totalPages = pages;
                  _currentPage = 1; // Set the initial page number
                });
              }
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  '$_currentPage/$_totalPages',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
