import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imp_approval/objectbox.g.dart';
import 'package:imp_approval/controller/store_manager.dart';

@Entity()
class Notifications {
	String? androidAccentColor;
	String? appId;
	String? bigPicture;
	bool? canceled;
	Contents? contents;
	int? converted;
	Data? data;
	String? delayedOption;
	int? errored;
	int? failed;
	String? globalImage;
	Contents? headings;
	int? id;
	List<String>? includePlayerIds;
	bool? isAdm;
	bool? isAndroid;
	bool? isChrome;
	bool? isChromeWeb;
	bool? isAlexa;
	bool? isFirefox;
	bool? isIos;
	bool? isSafari;
	bool? isWP;
	bool? isWPWNS;
	bool? isEdge;
	bool? isHuawei;
	bool? isSMS;
	String? largeIcon;
	int? priority;
	int? queuedAt;
	int? remaining;
	int? sendAfter;
	int? completedAt;
	String? smallIcon;
	int? successful;
	String? tags;
	String? filters;
	String? templateId;
	int? ttl;
	String? url;
	String? webUrl;
	String? appUrl;
	PlatformDeliveryStats? platformDeliveryStats;
  int? includeExternalUserIds;
	String? includeAliases;
	String? fcapStatus;
	String? smsFrom;
	String? smsMediaUrls;
	String? subtitle;
	String? name;
	String? emailClickTrackingDisabled;
	bool? isEmail;
	String? emailSubject;
	String? emailFromName;
	String? emailFromAddress;
	String? emailPreheader;
	String? emailReplyToAddress;
	bool? includeUnsubscribed;
	int? threadId;
    @Id(assignable: true)
  int serverId = 0;

	Notifications({ this.androidAccentColor, this.appId, this.bigPicture, this.canceled,  this.contents, this.converted, this.data, this.delayedOption,this.errored, this.failed, this.globalImage, this.headings, this.id, this.includePlayerIds, this.includeExternalUserIds, this.includeAliases, this.threadId, this.isAdm, this.isAndroid, this.isChrome, this.isChromeWeb, this.isAlexa, this.isFirefox, this.isIos, this.isSafari, this.isWP, this.isWPWNS, this.isEdge, this.isHuawei, this.isSMS, this.largeIcon, this.priority, this.queuedAt, this.remaining, this.sendAfter, this.completedAt, this.smallIcon, this.successful, this.tags, this.filters, this.templateId, this.ttl, this.url, this.webUrl, this.appUrl,this.platformDeliveryStats, this.fcapStatus, this.smsFrom, this.smsMediaUrls, this.subtitle, this.name, this.emailClickTrackingDisabled, this.isEmail, this.emailSubject, this.emailFromName, this.emailFromAddress, this.emailPreheader, this.emailReplyToAddress, this.includeUnsubscribed, required this.serverId});

	Notifications.fromJson(Map<String, dynamic> json) {
		androidAccentColor = json['android_accent_color'];
		serverId = json['serverId'];
		appId = json['app_id'];
		bigPicture = json['big_picture'];
		canceled = json['canceled'];
		contents = json['contents'] != String ? new Contents.fromJson(json['contents']) : null;
		converted = json['converted'];
		data = json['data'] != null ? new Data.fromJson(json['data']) : null;
		delayedOption = json['delayed_option'];
		errored = json['errored'];
		failed = json['failed'];
		globalImage = json['global_image'];
		headings = json['headings'] != null ? new Contents.fromJson(json['headings']) : null;
		id = json['id'];
		includePlayerIds = json['include_player_ids'].cast<String>();
		includeExternalUserIds = json['include_external_user_ids'];
		includeAliases = json['include_aliases'];
		threadId = json['thread_id'];
		isAdm = json['isAdm'];
		isAndroid = json['isAndroid'];
		isChrome = json['isChrome'];
		isChromeWeb = json['isChromeWeb'];
		isAlexa = json['isAlexa'];
		isFirefox = json['isFirefox'];
		isIos = json['isIos'];
		isSafari = json['isSafari'];
		isWP = json['isWP'];
		isWPWNS = json['isWP_WNS'];
		isEdge = json['isEdge'];
		isHuawei = json['isHuawei'];
		isSMS = json['isSMS'];
		largeIcon = json['large_icon'];
		priority = json['priority'];
		queuedAt = json['queued_at'];
		remaining = json['remaining'];
		sendAfter = json['send_after'];
		completedAt = json['completed_at'];
		smallIcon = json['small_icon'];
		successful = json['successful'];
		tags = json['tags'];
		filters = json['filters'];
		templateId = json['template_id'];
		ttl = json['ttl'];
		url = json['url'];
		webUrl = json['web_url'];
		appUrl = json['app_url'];
		platformDeliveryStats = json['platform_delivery_stats'] != null ? new PlatformDeliveryStats.fromJson(json['platform_delivery_stats']) : null;
		fcapStatus = json['fcap_status'];
		smsFrom = json['sms_from'];
		smsMediaUrls = json['sms_media_urls'];
		subtitle = json['subtitle'];
		name = json['name'];
		emailClickTrackingDisabled = json['email_click_tracking_disabled'];
		isEmail = json['isEmail'];
		emailSubject = json['email_subject'];
		emailFromName = json['email_from_name'];
		emailFromAddress = json['email_from_address'];
		emailPreheader = json['email_preheader'];
		emailReplyToAddress = json['email_reply_to_address'];
		includeUnsubscribed = json['include_unsubscribed'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		
		data['app_id'] = this.appId;
		data['big_picture'] = this.bigPicture;
		data['canceled'] = this.canceled;
		if (this.contents != null) {
      data['contents'] = this.contents!.toJson();
    }
		data['converted'] = this.converted;
		if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
		data['delayed_option'] = this.delayedOption;
		data['errored'] = this.errored;
		data['failed'] = this.failed;
		data['global_image'] = this.globalImage;
		if (this.headings != null) {
      data['headings'] = this.headings!.toJson();
    }
		data['id'] = this.id;
		data['include_player_ids'] = this.includePlayerIds;
		data['include_external_user_ids'] = this.includeExternalUserIds;
		data['include_aliases'] = this.includeAliases;
		data['thread_id'] = this.threadId;
		data['isAdm'] = this.isAdm;
		data['isAndroid'] = this.isAndroid;
		data['isChrome'] = this.isChrome;
		data['isChromeWeb'] = this.isChromeWeb;
		data['isAlexa'] = this.isAlexa;
		data['isFirefox'] = this.isFirefox;
		data['isIos'] = this.isIos;
		data['isSafari'] = this.isSafari;
		data['isWP'] = this.isWP;
		data['isWP_WNS'] = this.isWPWNS;
		data['isEdge'] = this.isEdge;
		data['isHuawei'] = this.isHuawei;
		data['isSMS'] = this.isSMS;
		data['large_icon'] = this.largeIcon;
		data['priority'] = this.priority;
		data['queued_at'] = this.queuedAt;
		data['remaining'] = this.remaining;
		data['send_after'] = this.sendAfter;
		data['completed_at'] = this.completedAt;
		data['small_icon'] = this.smallIcon;
		data['successful'] = this.successful;
		data['tags'] = this.tags;
		data['filters'] = this.filters;
		data['template_id'] = this.templateId;
		data['ttl'] = this.ttl;
		data['url'] = this.url;
		data['web_url'] = this.webUrl;
		data['app_url'] = this.appUrl;
		if (this.platformDeliveryStats != null) {
      data['platform_delivery_stats'] = this.platformDeliveryStats!.toJson();
    }
		data['fcap_status'] = this.fcapStatus;
		data['sms_from'] = this.smsFrom;
		data['sms_media_urls'] = this.smsMediaUrls;
		data['subtitle'] = this.subtitle;
		data['name'] = this.name;
		data['email_click_tracking_disabled'] = this.emailClickTrackingDisabled;
		data['isEmail'] = this.isEmail;
		data['email_subject'] = this.emailSubject;
		data['email_from_name'] = this.emailFromName;
		data['email_from_address'] = this.emailFromAddress;
		data['email_preheader'] = this.emailPreheader;
		data['email_reply_to_address'] = this.emailReplyToAddress;
		data['include_unsubscribed'] = this.includeUnsubscribed;
		return data;
	}
}

class Contents {
	String? en;

	Contents({this.en});

	Contents.fromJson(Map<String, dynamic> json) {
		en = json['en'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['en'] = this.en;
		return data;
	}
}

class Data {
	String? userId;
	String? name;
	int? divisiId;
	String? avatar;

	Data({this.userId, this.name, this.divisiId, this.avatar});

	Data.fromJson(Map<String, dynamic> json) {
		userId = json['user_id'];
		name = json['name'];
		divisiId = json['divisi_id'];
		avatar = json['avatar'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_id'] = this.userId;
		data['name'] = this.name;
		data['divisi_id'] = this.divisiId;
		data['avatar'] = this.avatar;
		return data;
	}
}



class PlatformDeliveryStats {
	Android? android;
	Android? chromeWebPush;

	PlatformDeliveryStats({this.android, this.chromeWebPush});

	PlatformDeliveryStats.fromJson(Map<String, dynamic> json) {
		android = json['android'] != null ? new Android.fromJson(json['android']) : null;
		chromeWebPush = json['chrome_web_push'] != null ? new Android.fromJson(json['chrome_web_push']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
		if (this.chromeWebPush != null) {
      data['chrome_web_push'] = this.chromeWebPush!.toJson();
    }
		return data;
	}
}

class Android {
	int? successful;
	int? failed;
	int? errored;
	int? converted;
	int? received;
	int? suppressed;

	Android({this.successful, this.failed, this.errored, this.converted, this.received, this.suppressed});

	Android.fromJson(Map<String, dynamic> json) {
		successful = json['successful'];
		failed = json['failed'];
		errored = json['errored'];
		converted = json['converted'];
		received = json['received'];
		suppressed = json['suppressed'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['successful'] = this.successful;
		data['failed'] = this.failed;
		data['errored'] = this.errored;
		data['converted'] = this.converted;
		data['received'] = this.received;
		data['suppressed'] = this.suppressed;
		return data;
	}
}

Future<List<Notifications>> fetchAllNotifications() async {
  String url =
      'https://onesignal.com/api/v1/notifications?app_id=d0249df4-3456-48a0-a492-9c5a7f6a875e';
  print("Fetching data from URL: $url");

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic MGEwNDI0NmMtOWIyMC00YzU5LWI3NDYtNzUxMjFjYjdmZGJj', 
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data["notifications"] == null) {
        print("Null.");
        return [];
      }

      if (data["notifications"] is List) {
        List<Notifications> notificationsList = (data["notifications"] as List)
            .map((item) => Notifications.fromJson(item))
            .toList();

        if (notificationsList.isNotEmpty) {
          return notificationsList;
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




Future<void> updateCacheWithAllData(List<Notifications> notificationsFromServer) async {
  final storeManager = await StoreManager.getInstance();
  final box = storeManager.store.box<Notifications>();

  for (var notification in notificationsFromServer) {
   final existingNotification = box.get(notification.serverId);

  if (existingNotification == null) {
      box.put(notification); 
  }

  }
  print("Cache update process completed.");
}

Future<List<Notifications>> fetchAndUpdateCache() async {

  final notifications = await fetchAllNotifications();
  await updateCacheWithAllData(notifications);

  return notifications;
}
