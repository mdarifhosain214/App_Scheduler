import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

/// Service for showing local notifications when scheduled apps are launched.
/// Called from the Flutter side after detecting native-side app launches.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    // Create notification channel (Android 8+)
    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDesc,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Show a notification that a scheduled app was launched.
  static Future<void> showLaunchNotification({
    required int id,
    required String appName,
    bool success = true,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id,
      success ? 'App Launched' : 'Launch Failed',
      success
          ? '$appName was launched as scheduled.'
          : 'Failed to launch $appName.',
      details,
    );
  }
}
