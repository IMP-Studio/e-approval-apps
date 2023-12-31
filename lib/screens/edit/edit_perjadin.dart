import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class EditPerjadin extends StatefulWidget {
  final Map absen;
  const EditPerjadin({super.key, required this.absen});

  @override
  State<EditPerjadin> createState() => _EditPerjadinState();
}

class _EditPerjadinState extends State<EditPerjadin>
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

  FilePickerResult? _pickedFile;


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xls', 'xlsx', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result;
      });
    } else {
      // User canceled the picker
    }
  }

  Future updatePresence() async {
    String? filePath = _pickedFile?.files.first.path;
    int idPerjadin = widget.absen['id'];
    var uri = Uri.parse(
        'https://admin.approval.impstudio.id/api/presence/update/$idPerjadin');

    var request = http.MultipartRequest('POST', uri)
      ..fields['_method'] = 'PUT'
      ..fields['user_id'] = widget.absen['user_id'].toString()
      ..fields['status'] = 'pending'
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

    // Add file to the request only if it's not null
    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    try {
      var response = await request.send();

      print("Request Headers: ${request.headers}");
      print("Request Fields: ${request.fields}");
      if (filePath != null) {
        print("File Path: $filePath");
      }
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return json.decode(responseData);
      } else {
        print("Error with status code: ${response.statusCode}");
        var responseData = await response.stream.bytesToString();
        print("Error Details: $responseData");
      }
    } catch (e) {
      print("Error during request execution: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                    const Icon(
                      LucideIcons.chevronLeft,
                      color: kButton,
                    ),
                    Text(
                      'Kembali',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: kButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30),
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
                          "Ajukan",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Perjadin",
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
                        "Perjadin mu akan di proses oleh HT & Management.",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // form
              Row(
                children: [
                  Text('Upload file',
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w600,
                      )),
                  const Text('*',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      )),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kBorder,
                    width: 1,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _pickFile,
                  child: Row(
                    children: [
                      Expanded(
                        // Wrapping Text widget in Flexible
                        child: Text(
                          _pickedFile != null
                              ? '${_pickedFile!.files.first.name}'
                              : '${widget.absen['originalFile']}',
                          overflow: TextOverflow.ellipsis, // Ellipsis overflow
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: kTextgrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        LucideIcons.arrowDownCircle,
                        color: kBorder,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 110,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                  _pickedFile?.files.first.path,
                                );
                                print(widget.absen['id']);

                                updatePresence().then((value) {
                                  Navigator.pop(context); // Pop once
                                  Navigator.pop(
                                      context, 'refresh'); // Pop again
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: kButton,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Update Perjadin',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: whiteText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                      ],
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
