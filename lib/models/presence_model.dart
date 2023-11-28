import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';
import 'standup_model.dart';
StoreManager? storeManager;

@Entity()
class Presences {
  int? id;
  int? userId;
  String? namaLengkap;
  String? posisi;
  List<String>? permission;
  String? category;
  String? entryTime;
  String? exitTime;
  String? date;
  String? latitude;
  String? longitude;
  String? emergencyDescription;
  String? createdAt;
  String? updatedAt;
  final standupFR = ToMany<StandUps>();
  String? file;
  String? originalFile;
  String? startDate;
  String? endDate;
  String? entryDate;
  String? facePoint;
  int? statusCommitId;
  String? status;
  String? statusDescription;
  String? categoryDescription;
  String? teleworkCategory;
  String? type;
  String? descriptionLeave;
  String? submissionDate;
  String? totalLeaveDays;
  int? substituteId;
  String? substituteName;
  String? substituteDivision;
  String? substitutePosition;
  @Id(assignable: true)
  int serverId = 0;

  List<StandUps> getStandUps() {
    if (storeManager != null) {
      return storeManager!.store.box<StandUps>().getAll().where((s) => standupFR.contains(s)).toList();
    } else {
      throw Exception('storeManager is not initialized');
    }
  }

  Presences(
      {this.id,
      this.userId,
      this.namaLengkap,
      this.posisi,
      this.permission,
      this.category,
      this.entryTime,
      this.exitTime,
      this.date,
      this.latitude,
      this.longitude,
      this.emergencyDescription,
      this.createdAt,
      this.updatedAt,
      this.file,
      this.originalFile,
      this.startDate,
      this.endDate,
      this.entryDate,
      this.facePoint,
      this.statusCommitId,
      this.status,
      this.statusDescription,
      this.categoryDescription,
      this.teleworkCategory,
      this.type,
      this.descriptionLeave,
      this.submissionDate,
      this.totalLeaveDays,
      this.substituteId,
      this.substituteName,
      this.substituteDivision,
      this.substitutePosition,
      required this.serverId});

  Presences.fromJson(Map<String, dynamic> json) {
    serverId = json['id'];
    id = json['id'];
    userId = json['user_id'];
    namaLengkap = json['nama_lengkap'];
    posisi = json['posisi'];
    permission = json['permission'].cast<String>();
    category = json['category'];
    entryTime = json['entry_time'];
    exitTime = json['exit_time'];
    date = json['date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    emergencyDescription = json['emergency_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    file = json['file'];
    originalFile = json['originalFile'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    entryDate = json['entry_date'];
    facePoint = json['face_point'];
    statusCommitId = json['status_commit_id'];
    status = json['status'];
    statusDescription = json['status_description'];
    categoryDescription = json['category_description'];
    teleworkCategory = json['telework_category'];
    type = json['type'];
    descriptionLeave = json['description_leave'];
    submissionDate = json['submission_date'];
    totalLeaveDays = json['total_leave_days'];
    substituteId = json['substitute_id'];
    substituteName = json['substitute_name'];
    substituteDivision = json['substitute_division'];
    substitutePosition = json['substitute_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['nama_lengkap'] = namaLengkap;
    data['posisi'] = posisi;
    data['permission'] = permission;
    data['category'] = category;
    data['entry_time'] = entryTime;
    data['exit_time'] = exitTime;
    data['date'] = date;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['emergency_description'] = emergencyDescription;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    // You should remove the handling of 'standups' here.

    data['file'] = file;
    data['originalFile'] = originalFile;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['entry_date'] = entryDate;
    data['face_point'] = facePoint;
    data['status_commit_id'] = statusCommitId;
    data['status'] = status;
    data['status_description'] = statusDescription;
    data['category_description'] = categoryDescription;
    data['telework_category'] = teleworkCategory;
    data['type'] = type;
    data['description_leave'] = descriptionLeave;
    data['submission_date'] = submissionDate;
    data['total_leave_days'] = totalLeaveDays;
    data['substitute_id'] = substituteId;
    data['substitute_name'] = substituteName;
    data['substitute_division'] = substituteDivision;
    data['substitute_position'] = substitutePosition;
    return data;
  }
}


  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return ''; // handle null datetime if necessary
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

Future<List<Presences>> fetchAllPresences(
    String userId, String scope, String status, String type,
    DateTime? startDate, DateTime? endDate) async {
  String url =
      'https://testing.impstudio.id/approvall/api/presence?id=$userId&scope=$scope&status=$status';

  if (startDate != null) {
    url += '&start_date=${formatDate(startDate)}';
  }

  if (endDate != null) {
    url += '&end_date=${formatDate(endDate)}';
  }

  if (type != null && type.isNotEmpty) { // Use && instead of ||
    url += '&type=$type';
  }

  print("Fetching data from URL: $url");

  try {
    final response = await http.get(Uri.parse(url));
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("data") && data["data"] is List) {
        List<Presences> presencesList = (data["data"] as List)
            .map((item) => Presences.fromJson(item))
            .toList();

        if (presencesList.isNotEmpty) {
          print("Parsed data to Presences objects: $presencesList");
          return presencesList;
        } else {
          print("No presences data found in the response.");
          return [];
        }
      } else if (data["data"] == null) {
        print("No presences data found in the response.");
        return [];
      } else {
        throw Exception('Unexpected format in JSON response.');
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



Future<void> updateCacheWithAllData(List<Presences> presencesFromServer) async {
  print(
      "Starting cache update with ${presencesFromServer.length} presences from server.");

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<Presences>();

  for (var presence in presencesFromServer) {
    final existingPresence = box.get(presence.serverId);

    if (existingPresence == null) {
      print(
          "Presence with ID: ${presence.serverId} does not exist in cache. Adding...");
      box.put(presence); // No need to set the id, it's directly mapped now.
    } else {
      final existingUpdatedAt = DateTime.parse(existingPresence.updatedAt!);
      final newUpdatedAt = DateTime.parse(presence.updatedAt!);

      if (newUpdatedAt.isAfter(existingUpdatedAt)) {
        print(
            "Presence with ID: ${presence.serverId} has newer data. Updating cache...");
        box.put(
            presence); // Directly put it. ObjectBox will recognize it as an update.
      } else {
        print(
            "Presence with ID: ${presence.serverId} is up-to-date. Skipping cache update.");
      }
    }
  }
  print("Cache update process completed.");
}

Future<List<Presences>> fetchAndUpdateCache(String userId, String scope, String status, int? activeIndex, DateTime? startDate, DateTime? endDate) async {
  print("Starting fetch and update process for presence");

  // Initialize the storeManager
  storeManager = await StoreManager.getInstance();

  // Determine type based on activeIndex
  String type = activeIndex == 0 ? '': activeIndex == 1 ? 'WFA' : activeIndex == 2 ? 'PERJADIN' : '';

  // Fetching all presences...
  print("Fetching all presences...");
  final presences = await fetchAllPresences(userId, scope, status, type, startDate, endDate);
  print("Successfully fetched ${presences.length} presences.");

  // Updating cache
  print("Updating cache with fetched presences...");
  await updateCacheWithAllData(presences);
  print("Cache updated successfully.");

  // Access the standups
  for (var presence in presences) {
    final standups = presence.getStandUps();
    print("StandUps for Presence with ID ${presence.id}: $standups");
  }

  return presences;
}
