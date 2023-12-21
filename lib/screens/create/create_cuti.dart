import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/detail/detail_syarat_cuti_khusus.dart';
import 'package:imp_approval/screens/detail/detail_syarat_cuti_darurat.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shimmer/shimmer.dart';

class CreateCuti extends StatefulWidget {
  final Map profile;
  final Map yearly;
  const CreateCuti({super.key, required this.profile, required this.yearly});

  @override
  State<CreateCuti> createState() => _CreateCutiState();
}

class _CreateCutiState extends State<CreateCuti> with WidgetsBindingObserver {
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
      margin: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top + 10), // Adjust margin for top
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
                    const SizedBox(width: 15),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [customIcon]),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
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
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2)),
                              Text(
                                submessage,
                                style: GoogleFonts.getFont('Montserrat',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10),
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
                height: 50,
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
      duration: const Duration(seconds: 3), // Reduced duration
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});

    getUserData().then((_) {
      fetchData();
    });
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  String? selectedSubtitue;
  String? selectedValueType;
  String? selectedValueExclusive;
  String? selectedValueEmergency;

  TextEditingController subtitueCont = TextEditingController();

  String selectedOption = '';
  // date
  DateTime? _mulaiTanggal;
  DateTime? _selesaiTanggal;
  DateTime? _tanggalMasuknya;

  FilePickerResult? _pickedFile;
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result;
      });
    } else {
      // User canceled the picker
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool isButtonDisabled = false;

  TextEditingController mulai_cuti = TextEditingController();
  TextEditingController akhir_cuti = TextEditingController();
  TextEditingController tanggal_masuk = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchLeaveOptions() async {
    final response = await http.get(
        Uri.parse('https://testing.impstudio.id/approvall/api/leave/option'));
    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse['message'] == 'Success') {
        return List<Map<String, dynamic>>.from(parsedResponse['data']);
      } else {
        throw Exception(parsedResponse['message']);
      }
    } else {
      throw Exception('Failed to load leave options');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSubtitue() async {



    final response = await http.get(Uri.parse(
        'https://testing.impstudio.id/approvall/api/user'));
    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse['message'] == 'Success') {
        return List<Map<String, dynamic>>.from(parsedResponse['data']);
      } else {
        throw Exception(parsedResponse['message']);
      }
    } else {
      throw Exception('Failed to load leave options');
    }
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> fetchedData = await fetchLeaveOptions();
    List<Map<String, dynamic>> fetchedData2 = await fetchSubtitue();
    setState(() {
      leaveOptions = fetchedData;
      subtitue = fetchedData2;
    });
  }

  Future<List<Map<String, dynamic>>> getSearchSuggestions(
      String pattern) async {
    // Convert the search pattern to lowercase for case-insensitive search
    String lowerCasePattern = pattern.toLowerCase();

    // Filter the list based on the lowercase pattern
    return subtitue
        .where((user) => user['name'].toLowerCase().contains(lowerCasePattern))
        .toList();
  }

  List<Map<String, dynamic>> leaveOptions = [];
  List<Map<String, dynamic>> subtitue = [];

  bool isKhususSelected = false;
  bool isDaruratSelected = false;
  String? selectedValue;

  Future storeCuti() async {
    if (_mulaiTanggal == null || _selesaiTanggal == null) {
      print("Error: Start or end date not selected.");
      return;
    }

    var uri =
        Uri.parse('https://testing.impstudio.id/approvall/api/leave/store');

    // Determine the correct selected value based on leave type
    String? leaveDetailId;

    if (selectedValueType == 'exclusive') {
      leaveDetailId = selectedValueExclusive;
    } else if (selectedValueType == 'emergency') {
      leaveDetailId = selectedValueEmergency;
    } else if (selectedValueType == 'yearly') {
      if (leaveOptions.any((option) => option['type_leave'] == 'yearly')) {
        final yearlyOption = leaveOptions
            .firstWhere((option) => option['type_leave'] == 'yearly');
        leaveDetailId = yearlyOption['id'].toString();
      } else {
        leaveDetailId = '1'; // Default fallback ID for yearly
      }
    } else {
      print("Unexpected selectedValueType: $selectedValueType");
      return;
    }

    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..fields['user_id'] = widget.profile['user_id'].toString()
      ..fields['leave_detail_id'] = leaveDetailId ?? ""
      ..fields['substitute_id'] = selectedSubtitue ?? ""
      ..fields['submission_date'] = DateTime.now().toIso8601String()
      ..fields['total_leave_days'] =
          (_selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1).toString()
      ..fields['start_date'] = formatDate(_mulaiTanggal!)
      ..fields['end_date'] = formatDate(_selesaiTanggal!)
      ..fields['entry_date'] = formatDate(_tanggalMasuknya!);

    if (_pickedFile != null && _pickedFile!.files.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _pickedFile!.files.first.path!,
      ));
    }

    try {
      http.StreamedResponse response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print(responseData);
      } else {
        print('Error response:');
        print(
            responseData); // Printing the actual server response for debugging
        print('Status code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  int computeTotalCuti() {
    if (_mulaiTanggal != null && _selesaiTanggal != null) {
      return _selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1;
    }
    return 0;
  }

  void autoFillDates() {
    if (_mulaiTanggal != null) {
      int leaveDuration = 0;

      if (selectedValueExclusive != null) {
        var selectedOption = leaveOptions.firstWhere(
          (option) => option['id'].toString() == selectedValueExclusive,
          orElse: () => {},
        );

        // ignore: unnecessary_null_comparison
        if (selectedOption != null && selectedOption.containsKey('days')) {
          leaveDuration = selectedOption['days'];
        }
      } else if (selectedValueEmergency != null) {
        var selectedOption = leaveOptions.firstWhere(
          (option) => option['id'].toString() == selectedValueEmergency,
          orElse: () => {},
        );

        // ignore: unnecessary_null_comparison
        if (selectedOption != null && selectedOption.containsKey('days')) {
          leaveDuration = selectedOption['days'];
        }
      }

      if (leaveDuration > 0) {
        _selesaiTanggal = calculateEndDate(_mulaiTanggal!, leaveDuration);
        _tanggalMasuknya = calculateEntryDate(_selesaiTanggal!);
      }
    }
  }

  // date
  Future<void> _memulaiTanggal() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _mulaiTanggal ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _mulaiTanggal = newDate;
        autoFillDates(); // Call the refactored logic
      });
    }
  }

// Helper function to calculate entry date while skipping weekends
  DateTime _calculateEntryDate(DateTime endDate) {
    DateTime entryDate = endDate.add(const Duration(days: 1));
    while (entryDate.weekday == DateTime.saturday ||
        entryDate.weekday == DateTime.sunday) {
      entryDate = entryDate.add(const Duration(days: 1));
    }
    return entryDate;
  }

  Future<void> _tanggalMasuk() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _tanggalMasuknya ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _tanggalMasuknya = newDate;
      });
    }
  }

  Future<void> _selesaiTanggall() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selesaiTanggal ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _selesaiTanggal = newDate;
      });
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + ' ...';
    }
  }

  bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  DateTime calculateEndDate(DateTime startDate, int days) {
    DateTime endDate = startDate.add(Duration(days: days - 1));
    return endDate;
  }

  DateTime calculateEntryDate(DateTime endDate) {
    DateTime entryDate = endDate.add(const Duration(days: 1));
    while (isWeekend(entryDate)) {
      entryDate = entryDate.add(const Duration(days: 1));
    }
    return entryDate;
  }

  Widget _shimmerSelect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Base color for the shimmer effect
      highlightColor:
          Colors.grey[100]!, // Highlight color for the shimmer effect
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 90, // Adjust width according to the longest word.
                height: 12,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Container(
                width: 10,
                height: 12,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 5),
          Container(
            width:
                170, // Adjust width according to '*Syarat & Ketentuan berlaku.'
            height: 12,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity, // Adjust width here
            height: 50,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _selectedkhusus() {
    if (leaveOptions.isEmpty) {
      return _shimmerSelect(); // Show a loader while waiting for data.
    }

    var kepentinganCutiOptions = leaveOptions
        .where((option) => option['type_of_leave_id'] == 2)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Cuti Khusus',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: kepentinganCutiOptions.any(
                  (option) => option['id'].toString() == selectedValueExclusive)
              ? selectedValueExclusive
              : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          hint: Text(
            'Pilih kepentingan cuti',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: kTextgrey,
            ),
          ),
          items: kepentinganCutiOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['id'].toString(),
              child: Text(
                option['description_leave'],
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValueExclusive = value!;
              isButtonDisabled = true;
              autoFillDates();
            });
          },
          icon: const Icon(
            LucideIcons.arrowDownCircle,
            color: Color(0xffB6B6B6),
            size: 17,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailSyaratCutiKhusus(),
                    ));
              },
              child: Text(
                '*Syarat & Ketentuan berlaku.',
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kTextUnselected,
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity, // Adjust the width here
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kBorder,
              width: 1,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        : 'Pilih Berkas',
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
      ],
    );
  }

  Widget _selecteddarurat() {
    if (leaveOptions.isEmpty) {
      return _shimmerSelect(); // Show a loader while waiting for data.
    }

    var daruratCutiOptions = leaveOptions
        .where((option) => option['type_of_leave_id'] == 3)
        .toList(); // Assuming 3 represents Darurat

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Cuti Darurat',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: daruratCutiOptions.any(
                  (option) => option['id'].toString() == selectedValueEmergency)
              ? selectedValueEmergency
              : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          hint: Text(
            'Pilih darurat cuti',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: kTextgrey,
            ),
          ),
          items: daruratCutiOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['id'].toString(),
              child: Text(
                option['description_leave'],
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValueEmergency = value!;
              isButtonDisabled = true;
              autoFillDates();
            });
          },
          icon: const Icon(
            LucideIcons.arrowDownCircle,
            color: Color(0xffB6B6B6),
            size: 17,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailSyaratCutiDarurat(),
                    ));
              },
              child: Text(
                '*Syarat & Ketentuan berlaku.',
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kTextUnselected,
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity, // Adjust the width here
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kBorder,
              width: 1,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                  child: Text(
                    _pickedFile != null
                        ? '${_pickedFile!.files.first.name}'
                        : 'Pilih Berkas',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: kTextgrey,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Add this to truncate the text with an ellipsis
                    softWrap: false,
                  ),
                ),
                const Icon(
                  LucideIcons.arrowDownCircle,
                  color: kBorder,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool areInputsValid() {
    DateTime now = DateTime.now();

    if (selectedValueType == null) {
      showSnackbarWarning(
          "Fail...",
          "Jenis cuti belum dipilih",
          kTextBlocker,
          const Icon(
            LucideIcons.xCircle,
            size: 26.0,
            color: kTextBlocker,
          ));
      return false;
    }

    if (subtitueCont.text.isEmpty) {
      showSnackbarWarning(
          "Fail...",
          "Pilih penggantimu",
          kTextBlocker,
          const Icon(
            LucideIcons.xCircle,
            size: 26.0,
            color: kTextBlocker,
          ));
      return false;
    }

    if (subtitueCont.text ==
        preferences?.getString('nama_lengkap').toString()) {
      showSnackbarWarning(
          "Fail...",
          "Tidak bisa menggantikan dengan diri sendiri",
          kTextBlocker,
          const Icon(
            LucideIcons.xCircle,
            size: 26.0,
            color: kTextBlocker,
          ));
      return false;
    }

    if (_mulaiTanggal == null || _selesaiTanggal == null) {
      showSnackbarWarning(
          "Fail...",
          "Tanggal mulai atau akhir belum diisi",
          kTextBlocker,
          const Icon(
            LucideIcons.xCircle,
            size: 26.0,
            color: kTextBlocker,
          ));
      return false;
    }

    if (_tanggalMasuknya == null) {
      showSnackbarWarning(
          "Fail...",
          "Tanggal masuk belum diisi",
          kTextBlocker,
          const Icon(
            LucideIcons.xCircle,
            size: 26.0,
            color: kTextBlocker,
          ));
      return false;
    }

    if (selectedValueType == 'exclusive') {
      if (selectedValueExclusive == null) {
        showSnackbarWarning(
            "Fail...",
            "Cuti khusus belum dipilih",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      } else if (_pickedFile == null) {
        showSnackbarWarning(
            "Fail...",
            "File belum dipilih",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      } else if (_mulaiTanggal!.isBefore(now.add(const Duration(days: 4)))) {
        showSnackbarWarning(
            "Fail...",
            "Pengajuan cuti khusus harus H-5",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      }
    }

    if (selectedValueType == 'yearly') {
      if (widget.yearly['data'] == 12) {
        // The validation for not allowing leave when yearly['data'] is 12
        showSnackbarWarning(
            "Fail...",
            "Cuti tahunan mu sudah habis ",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
      } else if (_mulaiTanggal!.isBefore(now.add(const Duration(days: 4)))) {
        showSnackbarWarning(
            "Fail...",
            "Pengajuan cuti khusus harus H-5",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      } else {
        int duration = _selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1;
        if (duration > 3) {
          showSnackbarWarning(
              "Fail...",
              "Maksimal cuti berturut adalah 3 hari.",
              kTextBlocker,
              const Icon(
                LucideIcons.xCircle,
                size: 26.0,
                color: kTextBlocker,
              ));
          return false;
        }
      }
    }

    if (selectedValueType == 'emergency') {
      if (selectedValueEmergency == null) {
        showSnackbarWarning(
            "Fail...",
            "Cuti darurat belum dipilih",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      } else if (_pickedFile == null) {
        showSnackbarWarning(
            "Fail...",
            "File belum dipilih",
            kTextBlocker,
            const Icon(
              LucideIcons.xCircle,
              size: 26.0,
              color: kTextBlocker,
            ));
        return false;
      }
    }

    return true; // Return true if all validations pass.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              padding: const EdgeInsets.only(left: 3, right: 30),
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
                        "Permintaan",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Cuti",
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
                      "Permintaan akan di proses oleh HT & Management",
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
            Row(
              children: [
                Text(
                  'Jenis Cuti',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              hint: Text(
                'Pilih jenis cuti',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey,
                ),
              ),
              items: [
                DropdownMenuItem(
                    value: 'yearly',
                    child: Text(
                      'Tahunan',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: kTextgrey,
                      ),
                    )),
                DropdownMenuItem(
                    value: 'exclusive',
                    child: Text(
                      'Khusus',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: kTextgrey,
                      ),
                    )),
                DropdownMenuItem(
                    value: 'emergency',
                    child: Text(
                      'Darurat',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: kTextgrey,
                      ),
                    )),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Pilih jenis cuti.';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedValueType = value;
                  if (selectedValueType == 'yearly') {
                    isButtonDisabled = false;
                    _pickedFile = null;
                    _selesaiTanggal = null;
                    _tanggalMasuknya = null;
                  } else if (selectedValueType == 'exclusive') {
                    isButtonDisabled = true;
                    selectedValueEmergency = null;
                    // Call a function here to set _selesaiTanggal and _tanggalMasuknya based on _mulaiTanggal
                    // _calculateEndAndEntryDates();
                  } else if (selectedValueType == 'emergency') {
                    selectedValueExclusive = null;
                    // _calculateEndAndEntryDates();
                  }

                  isKhususSelected = selectedValueType == 'exclusive';
                  isDaruratSelected = selectedValueType == 'emergency';
                });
              },
              icon: const Icon(LucideIcons.arrowDownCircle,
                  color: Color(0xffB6B6B6), size: 17),
            ),
            const SizedBox(
              height: 15,
            ),
            TypeAheadField(
              debounceDuration:
                  const Duration(milliseconds: 300), // debouncing of 300ms
              textFieldConfiguration: TextFieldConfiguration(
                controller: subtitueCont,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: kTextgrey, // Or whatever color you want
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Pilih pengganti dirimu',
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: kTextgrey,
                  ),
                  suffixIcon: const Icon(LucideIcons.arrowDownCircle,
                      color: Color(0xffB6B6B6), size: 17),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return getSearchSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion['name'],
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: kTextgrey,
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                selectedSubtitue = suggestion['user_id'].toString();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    subtitueCont.text = suggestion['name'];
                  });
                });
              },
            ),
            if (isKhususSelected) _selectedkhusus(),
            if (isDaruratSelected) _selecteddarurat(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10, bottom: 5)),
                Row(
                  children: [
                    Text(
                      'Tanggal',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 15),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: kBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: _memulaiTanggal,
                        child: Row(
                          children: [
                            Text(
                              _mulaiTanggal != null
                                  ? "${_mulaiTanggal!.year}/${_mulaiTanggal!.month}/${_mulaiTanggal!.day}"
                                  : 'Mulai cuti',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kTextgrey,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              LucideIcons.calendar,
                              color: kBorder,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 15),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: kBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: isButtonDisabled ? null : _selesaiTanggall,
                        child: Row(
                          children: [
                            Text(
                              _selesaiTanggal != null
                                  ? "${_selesaiTanggal!.year}/${_selesaiTanggal!.month}/${_selesaiTanggal!.day}"
                                  : 'Akhir cuti',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kTextgrey,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              LucideIcons.calendar,
                              color: kBorder,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: kBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: isButtonDisabled ? null : _tanggalMasuk,
                  child: Row(
                    children: [
                      Text(
                        _tanggalMasuknya != null
                            ? "${_tanggalMasuknya!.year}/${_tanggalMasuknya!.month}/${_tanggalMasuknya!.day}"
                            : 'Tanggal Masuk',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kTextgrey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        LucideIcons.calendar,
                        color: kBorder,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Total Cuti : ${computeTotalCuti()} hari',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            if (areInputsValid()) {
                              print("Selected Value Type: $selectedValueType");
                              print("Selected Value Yearly: $selectedValue");
                              print(
                                  "Does yearly option exist: ${leaveOptions.any((option) => option['type_leave'] == 'yearly')}");
                              print(
                                  "Selected Value Exclusive: $selectedValueExclusive");
                              print(
                                  "Selected Value Emergency: $selectedValueEmergency");
                              print(
                                  "Mulai Tanggal: ${_mulaiTanggal?.toIso8601String()}");
                              print(
                                  "Selesai Tanggal: ${_selesaiTanggal?.toIso8601String()}");
                              print(
                                  "Tanggal Masuk: ${_tanggalMasuknya?.toIso8601String()}");
                              print(
                                  "Total Hari: ${(_selesaiTanggal!.difference(_mulaiTanggal!).inDays + 1).toString()}");
                              print("Pengganti : $selectedSubtitue");
                              if (_pickedFile != null &&
                                  _pickedFile!.files.isNotEmpty) {
                                print(
                                    "Picked File Path: ${_pickedFile!.files.first.path}");
                              }

                              setState(() {
                                storeCuti().then((value) {
                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: kButton,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Ajukan Cuti'),
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
    );
  }
}
