import 'package:flutter/material.dart';
import 'package:imp_approval/screens/edit/edit_perjadin.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:imp_approval/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:imp_approval/models/presence_model.dart';
import 'package:path_provider/path_provider.dart';

class DetailPerjadin extends StatefulWidget {
  final Presences absen;
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

class _DetailPerjadinState extends State<DetailPerjadin>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<File?> downloadFile(String url, String filename) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Get documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();
      print("Documents directory: ${documentsDirectory.path}");

      // Create the file path
      final filePath = '${documentsDirectory.path}/$filename';
      print("Attempting to save file to: $filePath");

      final file = File(filePath);

      // Before writing to the file, let's check if the directory exists.
      final parentDir = file.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(
            recursive: true); // Ensuring the directory structure exists.
      }

      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      print("Failed to download file. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error downloading file: $e");
  }
  return null;
}

Future<void> onDownloadButtonPressed() async {
  final filess = widget.absen.file.toString();
  final url = 'https://admin.approval.impstudio.id/storage/$filess';

  final downloadedFile = await downloadFile(url, filess);

  if (downloadedFile != null && downloadedFile.existsSync()) {
    print("File path: ${downloadedFile.path}");

    // Check the file extension and open accordingly
    if (filess.toLowerCase().endsWith(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PDFViewerScreen(filePath: downloadedFile.path),
        ),
      );
    } else {
      
    }
  } else {
    print("Failed to fetch the file or the file does not exist at the expected path");
    if (downloadedFile != null) {
      print("Expected file path: ${downloadedFile.path}");
    }
  }
}


  Widget _category(BuildContext context) {
    if (widget.absen.category == 'work_trip') {
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
    String url = 'https://admin.approval.impstudio.id/api/presence/get/' +
        widget.absen.serverId.toString();
    var response = await http.get(Uri.parse(url));
    print(response.body);
    return json.decode(response.body);
  }

  Future destroyPresence() async {
    String url = 'https://admin.approval.impstudio.id/api/presence/delete/' +
        widget.absen.serverId.toString();
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
    final statusAbsen = widget.absen.status?.toUpperCase();
    Widget getStatusRow(String status) {
      Color containerColor;
      Color textColor;
      String text;
      double width;

      switch (status) {
        case 'rejected':
          containerColor = const Color(0xffF9DCDC);
          textColor = const Color(0xffCA4343);
          text = 'Rejected';
          width = 0.16;
          break;
        case 'pending':
          containerColor = const Color(0xffFFEFC6);
          textColor = const Color(0xffFFC52D);
          text = 'Pending';
          width = 0.16;
          break;
        case 'preliminary':
          containerColor = const Color(0xffCAE2FF);
          textColor = const Color(0xffF4381CA);
          text = 'Preliminary';
          width = 0.20;
          break;
        case 'allowed':
          containerColor = kGreenAllow;
          textColor = kGreen;
          text = 'Allowed';
          width = 0.16;
          break;
        default:
          containerColor = Colors.grey;
          textColor = Colors.white;
          text = 'Unknown';
          width = 0.16;
      }

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.5),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * width,
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

    String currentStatus = widget.absen.status ?? 'Unknown';

    // ignore: unused_local_variable
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
                        radius: MediaQuery.of(context).size.width * 0.04,
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
                            widget.absen.namaLengkap ?? 'Unknown',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.absen.posisi ?? 'Unknown',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.026,
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
                              'Tanggal :  ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.absen.date ?? '0000-00-00'))}',
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
                                    widget.absen.originalFile ?? 'Unknown',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.absen.status == 'pending',
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.absen.status == 'pending',
                              child: FutureBuilder(
                                future: editPresence(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Shimmer.fromColors(
                                        baseColor: kButton.withOpacity(0.8),
                                        highlightColor:
                                            kButton.withOpacity(0.5),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                kButton.withOpacity(0.8),
                                            side: BorderSide(
                                              color: kButton.withOpacity(0.8),
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
                                          // ignore: unused_local_variable
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
                                      baseColor: kButton.withOpacity(0.8),
                                      highlightColor: kButton.withOpacity(0.5),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              kButton.withOpacity(0.8),
                                          side: BorderSide(
                                            color: kButton.withOpacity(0.8),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Visibility(
                              visible: widget.absen.status == 'pending',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Visibility(
                          visible: widget.absen.status == 'rejected' ||
                              widget.absen.status == 'allowed',
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.03),
                                width: MediaQuery.of(context).size.width *
                                    1 /
                                    1.12,
                                height: 1,
                                color:
                                    const Color(0xffC2C2C2).withOpacity(0.30),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('Approver Name',
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.040,
                                                  color: blueText,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text('Status : ${statusAbsen}',
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.030,
                                                  color: greyText,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '“',
                                              style: GoogleFonts.montserrat(
                                                color: kPrimary,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.039,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.absen
                                                      .statusDescription ??
                                                  '-',
                                              style: GoogleFonts.montserrat(
                                                color: greyText,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.039,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '”',
                                              style: GoogleFonts.montserrat(
                                                color: kPrimary,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.039,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          )),
                    ],
                  )
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
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    // Extracting the filename from the full file path
    String fileName = widget.filePath.split('/').last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: Text(
          fileName, // Display the name of the file here
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.filePath,
            onViewCreated: (PDFViewController pdfViewController) {},
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
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
