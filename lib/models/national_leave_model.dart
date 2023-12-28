import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';

@Entity()
class NationalLeaves {
   @Id(assignable: true)
  int? id;
  String? holidayDate;
  String? holidayName;
  bool? isNationalHoliday;

  NationalLeaves({this.holidayDate, this.holidayName, this.isNationalHoliday, required this.id});

  NationalLeaves.fromJson(Map<String, dynamic> json) {
    holidayName = json['id'];
    holidayDate = json['holiday_date'];
    holidayName = json['holiday_name'];
    isNationalHoliday = json['is_national_holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['holiday_date'] = this.holidayDate;
    data['holiday_name'] = this.holidayName;
    data['is_national_holiday'] = this.isNationalHoliday;
    return data;
  }
}

Future<List<NationalLeaves>> fetchAllNationalLeaves(String tahun) async {
  String url = 'https://api-harilibur.vercel.app/api?year=$tahun';
  print("Fetching data from URL: $url");

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is List) {
        List<NationalLeaves> nationalLeavesList = data
            .map((item) => NationalLeaves.fromJson(item))
            .where((leave) => leave.isNationalHoliday == true) 
            .toList();

        if (nationalLeavesList.isNotEmpty) {
          return nationalLeavesList;
        } else {
          print("Null.");
          return [];
        }
      } else if (data is Map<String, dynamic>) {
        if (data["data"] == null) {
          print("Null.");
          return [];
        }

        List<NationalLeaves> nationalLeavesList = (data["data"] as List)
            .map((item) => NationalLeaves.fromJson(item))
            .where((leave) => leave.isNationalHoliday == true) 
            .toList();

        if (nationalLeavesList.isNotEmpty) {
          return nationalLeavesList;
        } else {
          print("Null.");
          return [];
        }
      } else {
        throw Exception('Unexpected format in JSON response: $data');
      }
    } else {
      print("Error fetching data with status code: ${response.statusCode}");
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  } catch (error) {
    print("An error occurred during the fetch operation: $error");
    throw error;
  }
}





Future<void> updateCacheWithAllData(List<NationalLeaves> nationalLeavesFromServer) async {

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<NationalLeaves>();

  for (var leave in nationalLeavesFromServer) {
    final existingLeave = box.query(NationalLeaves_.holidayDate.equals(leave.holidayDate!)).build().findFirst();

    if (existingLeave == null) {
      box.put(leave);
    } else {
      if (leave.holidayDate != null) {
      }

      box.put(leave);
    }
  }
  print("Cache update process completed.");
}

Future<List<NationalLeaves>> fetchAndUpdateCached(String tahun) async {
 
  final nationalLeaves = await fetchAllNationalLeaves(tahun);
  await updateCacheWithAllData(nationalLeaves);

  return nationalLeaves;
}
