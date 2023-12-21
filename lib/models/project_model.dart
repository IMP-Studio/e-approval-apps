import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';

@Entity()
class Projects {
  int? id;
  int? partnerId;
  String? project;
  String? partner;
  String? partnerLogo;
  String? partnerDescription;
  String? startDate;
  String? endDate;
  int? durasi;
  String? status;
  String? createdAt;
  String? updatedAt;
  @Id(assignable: true)
  int serverId = 0; // This will store the ID from the server.

  Projects(
      {this.id,
      this.partnerId,
      this.project,
      this.partner,
      this.partnerLogo,
      this.partnerDescription,
      this.startDate,
      this.endDate,
      this.durasi,
      this.status,
      this.createdAt,
      this.updatedAt,
      required this.serverId});

  Projects.fromJson(Map<String, dynamic> json) {
    serverId = json['id'];
    id = json['id'];
    partnerId = json['partner_id'];
    project = json['project'];
    partner = json['partner'];
    partnerLogo = json['partner_logo'];
    partnerDescription = json['partner_description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    durasi = json['durasi'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['project'] = project;
    data['partner'] = partner;
    data['partner_logo'] = partnerLogo;
    data['partner_description'] = partnerDescription;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['durasi'] = durasi;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

Future<List<Projects>> fetchAllProjects() async {
  String url = 'https://testing.impstudio.id/approvall/api/project';
  print("Fetching data from URL: $url");

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("data") && data["data"] is List) {
        List<Projects> projectsList = (data["data"] as List)
            .map((item) => Projects.fromJson(item))
            .toList();

        if (projectsList.isNotEmpty) {
          print("Parsed data to Projects objects: $projectsList");
          return projectsList;
        } else {
          print("No projects data found in the response.");
          return [];
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


Future<void> updateCacheWithAllData(List<Projects> projectsFromServer) async {
  print(
      "Starting cache update with ${projectsFromServer.length} projects from server.");

  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<Projects>();

  for (var project in projectsFromServer) {
    final existingProject = box.get(project.serverId);

    if (existingProject == null) {
      print(
          "Project with ID: ${project.serverId} does not exist in cache. Adding...");
      box.put(project); // No need to set the id, it's directly mapped now.
    } else {
      final existingUpdatedAt = DateTime.parse(existingProject.updatedAt!);
      final newUpdatedAt = DateTime.parse(project.updatedAt!);

      if (newUpdatedAt.isAfter(existingUpdatedAt)) {
        print(
            "Project with ID: ${project.serverId} has newer data. Updating cache...");
        box.put(
            project); // Directly put it. ObjectBox will recognize it as an update.
      } else {
        print(
            "Project with ID: ${project.serverId} is up-to-date. Skipping cache update.");
      }
    }
  }
  print("Cache update process completed.");
}

Future<List<Projects>> fetchAndUpdateCache() async {
  print(
      "Starting fetch and update process for project");

  // Fetching all pro
  print("Fetching all projects...");
  final projects = await fetchAllProjects();
  print("Successfully fetched ${projects.length} projects.");

  // Updating cache
  print("Updating cache with fetched projects...");
  await updateCacheWithAllData(projects);
  print("Cache updated successfully.");

  return projects;
}
