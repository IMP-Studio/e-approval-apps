import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';

@Entity()
class Leaves {
  int? id;
  int? userId;
  int? substituteId;
  String? substituteName;
  String? substituteDivision;
  String? substitutePosition;
  String? namaLengkap;
  String? type;
  int? leaveDetailId;
  String? descriptionLeave;
  String? entryTime;
  String? category;
  String? posisi;
  String? submissionDate;
  String? startDate;
  String? endDate;
  String? entryDate;
  String? totalLeaveDays;
  String? file;
  String? originalFile;
  String? status;
  String? statusDescription;
  int? approverId;
  String? approverName;
  String? createdAt;
  String? updatedAt;
  @Id(assignable: true)
  int serverId = 0;

  Leaves(
      {this.id,
      this.userId,
      this.substituteId,
      this.substituteName,
      this.substituteDivision,
      this.substitutePosition,
      this.namaLengkap,
      this.type,
      this.leaveDetailId,
      this.descriptionLeave,
      this.entryTime,
      this.category,
      this.posisi,
      this.submissionDate,
      this.startDate,
      this.endDate,
      this.entryDate,
      this.totalLeaveDays,
      this.file,
      this.originalFile,
      this.status,
      this.statusDescription,
      this.approverId,
      this.approverName,
      this.createdAt,
      this.updatedAt,
      required this.serverId});

  Leaves.fromJson(Map<String, dynamic> json) {
    serverId = json['id'];
    id = json['id'];
    userId = json['user_id'];
    substituteId = json['substitute_id'];
    substituteName = json['substitute_name'];
    substituteDivision = json['substitute_division'];
    substitutePosition = json['substitute_position'];
    namaLengkap = json['nama_lengkap'];
    type = json['type'];
    leaveDetailId = json['leave_detail_id'];
    descriptionLeave = json['description_leave'];
    entryTime = json['entry_time'];
    category = json['category'];
    posisi = json['posisi'];
    submissionDate = json['submission_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    entryDate = json['entry_date'];
    totalLeaveDays = json['total_leave_days'];
    file = json['file'];
    originalFile = json['originalFile'];
    status = json['status'];
    statusDescription = json['status_description'];
    approverId = json['approver_id'];
    approverName = json['approver_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['substitute_id'] = substituteId;
    data['substitute_name'] = substituteName;
    data['substitute_division'] = substituteDivision;
    data['substitute_position'] = substitutePosition;
    data['nama_lengkap'] = namaLengkap;
    data['type'] = type;
    data['leave_detail_id'] = leaveDetailId;
    data['description_leave'] = descriptionLeave;
    data['entry_time'] = entryTime;
    data['category'] = category;
    data['posisi'] = posisi;
    data['submission_date'] = submissionDate;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['entry_date'] = entryDate;
    data['total_leave_days'] = totalLeaveDays;
    data['file'] = file;
    data['originalFile'] = originalFile;
    data['status'] = status;
    data['status_description'] = statusDescription;
    data['approver_id'] = approverId;
    data['approver_name'] = approverName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

Future<List<Leaves>> fetchAllLeaves(String userId, String jenisCuti) async {
  String url =
      'https://admin.approval.impstudio.id/api/leave?id=$userId&type=$jenisCuti';
  print("Fetching data from URL: $url");

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data["data"] == null) {
        print("No leaves data found in the response.");
        return [];
      }

      if (data["data"] is List) {
        List<Leaves> leavesList = (data["data"] as List)
            .map((item) => Leaves.fromJson(item))
            .toList();

        if (leavesList.isNotEmpty) {
          print("Parsed data to Leaves objects: $leavesList");
          return leavesList;
        } else {
          print("No leaves data found in the response.");
          return [];
        }
      } else {
        throw Exception('Unexpected format in JSON response: $data');
      }
    } else {
      print("Error fetching data. Response body: ${response.body}");
      throw Exception('Failed to load data.');
    }
  } catch (error) {
    print("An error occurred during the fetch operation: $error");
    throw error;
  }
}

Future<void> updateCacheWithAllData(List<Leaves> leavesFromServer) async {
  print(
      "Starting cache update with ${leavesFromServer.length} leaves from server.");

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<Leaves>();

  for (var leave in leavesFromServer) {
    final existingLeave = box.get(leave.serverId);

    if (existingLeave == null) {
      print(
          "Leave with ID: ${leave.serverId} does not exist in cache. Adding...");
      box.put(leave);
    } else {
      final existingUpdatedAt = DateTime.parse(existingLeave.updatedAt!);
      final newUpdatedAt = DateTime.parse(leave.updatedAt!);

      if (newUpdatedAt.isAfter(existingUpdatedAt)) {
        print(
            "Leave with ID: ${leave.serverId} has newer data. Updating cache...");
        box.put(
            leave); 
      } else {
        print(
            "Leave with ID: ${leave.serverId} is up-to-date. Skipping cache update.");
      }
    }
  }
  print("Cache update process completed.");
}

Future<List<Leaves>> fetchAndUpdateCache(
    String userId, String jenisCuti) async {
  print(
      "Starting fetch and update process for user ID: $userId with scope: $jenisCuti");

  print("Fetching all leaves...");
  final leaves = await fetchAllLeaves(userId, jenisCuti);
  print("Successfully fetched ${leaves.length} leaves.");

  print("Updating cache with fetched leaves...");
  await updateCacheWithAllData(leaves);
  print("Cache updated successfully.");

  return leaves;
}
