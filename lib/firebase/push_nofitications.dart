
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {

      // for iOS request permission
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // for testing print firebase messaging token
      String token = await _firebaseMessaging.getToken();
      print('FirebaseMessaging Token : $token');
    }
  }

  FirebaseMessaging getFirebaseMessaging() => _firebaseMessaging;

  static Future<dynamic> fcmBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print('Data : $data');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print('Notification : $notification');
    }
  }

}