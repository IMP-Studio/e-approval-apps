import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';
import 'standup_model.dart';
StoreManager? storeManager;

@Entity()
class Profile {
  int? id;
  int? userId;
  String? namaLengkap;
  String? divisi;
  int? divisionId;
  String? posisi;
  int? posisitionId;
  String? avatar;
  String? idNumber;
  String? gender;
  String? address;
  String? birthDate;
  int? isActive;
  List<String>? permission;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? role;
  String? password;
  String? facepoint;
  String? rememberToken;
  final standupFRs = ToMany<StandUps>();
  int? doneCount;
  int? doingCount;
  int? blockerCount;
  String? createdAt;
  String? updatedAt;
  @Id(assignable: true)
  int serverId = 0;

  List<StandUps> getStandUps() {
    if (storeManager != null) {
      return storeManager!.store.box<StandUps>().getAll().where((s) => standupFRs.contains(s)).toList();
    } else {
      throw Exception('storeManager is not initialized');
    }
  }

  Profile(
      {this.id,
      this.userId,
      this.namaLengkap,
      this.divisi,
      this.divisionId,
      this.posisi,
      this.posisitionId,
      this.avatar,
      this.idNumber,
      this.gender,
      this.address,
      this.birthDate,
      this.isActive,
      this.permission,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.role,
      this.password,
      this.facepoint,
      this.rememberToken,
      this.doneCount,
      this.doingCount,
      this.blockerCount,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    namaLengkap = json['nama_lengkap'];
    divisi = json['divisi'];
    divisionId = json['division_id'];
    posisi = json['posisi'];
    posisitionId = json['posisition_id'];
    avatar = json['avatar'];
    idNumber = json['id_number'];
    gender = json['gender'];
    address = json['address'];
    birthDate = json['birth_date'];
    isActive = json['is_active'];
    permission = json['permission'].cast<String>();
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    password = json['password'];
    facepoint = json['facepoint'];
    rememberToken = json['remember_token'];
    doneCount = json['done_count'];
    doingCount = json['doing_count'];
    blockerCount = json['blocker_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['nama_lengkap'] = namaLengkap;
    data['divisi'] = divisi;
    data['division_id'] = divisionId;
    data['posisi'] = posisi;
    data['posisition_id'] = posisitionId;
    data['avatar'] = avatar;
    data['id_number'] = idNumber;
    data['gender'] = gender;
    data['address'] = address;
    data['birth_date'] = birthDate;
    data['is_active'] = isActive;
    data['permission'] = permission;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['role'] = role;
    data['password'] = password;
    data['facepoint'] = facepoint;
    data['remember_token'] = rememberToken;
    data['done_count'] = doneCount;
    data['doing_count'] = doingCount;
    data['blocker_count'] = blockerCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

Future<List<Profile>> fetchProfile(
    String userId) async {
  String url =
      'https://testing.impstudio.id/approvall/api/profile?user_id=$userId';

  try {
    final response = await http.get(Uri.parse(url));
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("data") && data["data"] is List) {
        List<Profile> profileList = (data["data"] as List)
            .map((item) => Profile.fromJson(item))
            .toList();

        if (profileList.isNotEmpty) {
          print("Parsed data to Profile objects: $profileList");
          return profileList;
        } else {
          print("No profile data found in the response.");
          return [];  // Return an empty list when profile are null.
        }
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


Future<void> updateCacheWithAllData(List<Profile> profileFromServer) async {
  print(
      "Starting cache update with ${profileFromServer.length} profile from server.");

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<Profile>();

  for (var profile in profileFromServer) {
    final existingProfile = box.get(profile.serverId);

    if (existingProfile == null) {
      print(
          "Profile with ID: ${profile.serverId} does not exist in cache. Adding...");
      box.put(profile); // No need to set the id, it's directly mapped now.
    } else {
      final existingUpdatedAt = DateTime.parse(existingProfile.updatedAt!);
      final newUpdatedAt = DateTime.parse(profile.updatedAt!);

      if (newUpdatedAt.isAfter(existingUpdatedAt)) {
        print(
            "Profile with ID: ${profile.serverId} has newer data. Updating cache...");
        box.put(
            profile); // Directly put it. ObjectBox will recognize it as an update.
      } else {
        print(
            "Profile with ID: ${profile.serverId} is up-to-date. Skipping cache update.");
      }
    }
  }
  print("Cache update process completed.");
}

Future<List<Profile>> fetchAndUpdateCache(String userId) async {
  print("Starting fetch and update process for profile");

  // Initialize the storeManager
  storeManager = await StoreManager.getInstance();

  // Fetching all profile...
  print("Fetching all profile...");
  final profile = await fetchProfile(userId);
  print("Successfully fetched ${profile.length} profile.");

  // Updating cache
  print("Updating cache with fetched profile...");
  await updateCacheWithAllData(profile);
  print("Cache updated successfully.");

  // Access the standups
  for (var profile in profile) {
    final standups = profile.getStandUps();
    print("StandUps for Profile with ID ${profile.id}: $standups");
  }

  return profile;
}