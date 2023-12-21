import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';
import 'presence_model.dart';

@Entity()
class StandUps {
  int id = 0;
  int? userId;
  String? namaLengkap;
  int? prensenceId;
  String? prensenceCategory;
  int? projectId;
  String? project;
  String? partner;
  String? done;
  String? doing;
  String? jam;
  String? blocker;
  String? createdAt;
  String? updatedAt;
  final presenceFR = ToOne<Presences>();
  @Id(assignable: true)
  int serverId = 0;
  // This will store the ID from the server.

  StandUps({
    this.id = 0,
    this.userId,
    this.namaLengkap,
    this.prensenceId,
    this.prensenceCategory,
    this.projectId,
    this.project,
    this.partner,
    this.done,
    this.doing,
    this.jam,
    this.blocker,
    this.createdAt,
    this.updatedAt,
    required this.serverId,
  });

  StandUps.fromJson(Map<String, dynamic> json) {
    serverId = json['id'];
    id = json['id'];
    userId = json['user_id'];
    namaLengkap = json['nama_lengkap'];
    prensenceId = json['prensenceId'];
    if (prensenceId != null) {
      presenceFR.targetId = prensenceId;
    }

    prensenceCategory = json['prensence_category'];
    projectId = json['project_id'];
    project = json['project'];
    partner = json['partner'];
    done = json['done'];
    doing = json['doing'];
    jam = json['jam'];
    blocker = json['blocker'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['nama_lengkap'] = namaLengkap;
    data['prensence_id'] = prensenceId;
    data['prensence_category'] = prensenceCategory;
    data['project_id'] = projectId;
    data['project'] = project;
    data['partner'] = partner;
    data['done'] = done;
    data['doing'] = doing;
    data['jam'] = jam;
    data['blocker'] = blocker;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['prensenceId'] = presenceFR.targetId;
    return data;
  }
}

Future<List<StandUps>> fetchAllStandUps(String userId, String scope) async {
  String url =
      'https://testing.impstudio.id/approvall/api/standup?id=$userId&scope=$scope';
  print("Fetching data from URL: $url");

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("data") && data["data"] is List) {
        List<StandUps> standUpsList = (data["data"] as List)
            .map((item) => StandUps.fromJson(item))
            .toList();

        if (standUpsList.isNotEmpty) {
          print("Parsed data to StandUps objects: $standUpsList");
          return standUpsList;
        } else {
          print("No stand-ups data found in the response.");
          return [];
        }
      } else if (data["data"] == null) {
        print("No stand-ups data found in the response.");
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



Future<void> updateCacheWithAllData(List<StandUps> standUpsFromServer) async {
  print(
      "Starting cache update with ${standUpsFromServer.length} standups from server.");

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<StandUps>();

  for (var standUp in standUpsFromServer) {
   final existingStandUp = box.get(standUp.serverId);

if (existingStandUp == null) {
    print("StandUp with ID: ${standUp.serverId} does not exist in cache. Adding...");
    box.put(standUp); // No need to set the id, it's directly mapped now.
} else {
    final existingUpdatedAt = DateTime.parse(existingStandUp.updatedAt!);
    final newUpdatedAt = DateTime.parse(standUp.updatedAt!);

    if (newUpdatedAt.isAfter(existingUpdatedAt)) {
        print("StandUp with ID: ${standUp.serverId} has newer data. Updating cache...");
        box.put(standUp); // Directly put it. ObjectBox will recognize it as an update.
    } else {
        print("StandUp with ID: ${standUp.serverId} is up-to-date. Skipping cache update.");
    }
    
    // Periksa apakah ada perubahan dalam relasi Presences
    if (existingStandUp.presenceFR.targetId != standUp.presenceFR.targetId) {
        print("StandUp with ID: ${standUp.serverId} has a different presence. Updating relation...");
        existingStandUp.presenceFR.targetId = standUp.presenceFR.targetId;
        box.put(existingStandUp);
    }
}

  }
  print("Cache update process completed.");
}

Future<List<StandUps>> fetchAndUpdateCache(String userId, String scope) async {
  print(
      "Starting fetch and update process for user ID: $userId with scope: $scope");

  // Fetching all standups
  print("Fetching all standups...");
  final standUps = await fetchAllStandUps(userId, scope);
  print("Successfully fetched ${standUps.length} standups.");

  // Updating cache
  print("Updating cache with fetched standups...");
  await updateCacheWithAllData(standUps);
  print("Cache updated successfully.");

  return standUps;
}
