import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Har kuni belgilangan vaqtda mashg'ulot eslatmasi (telefonning o'zida, serversiz).
class ReminderService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _id = 1;
  static bool _ready = false;

  /// Eslatmalar faqat Android ilovasida (veb versiyada yo'q).
  static bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    // Ilova Chexiyada yashovchilar uchun: vaqt Praga vaqti bo'yicha (yozgi vaqt hisobga olinadi).
    tz.setLocalLocation(tz.getLocation('Europe/Prague'));
    await _plugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    );
    _ready = true;
  }

  /// Android 13+ da bildirishnomaga ruxsat so'raydi. Ruxsat berilsa — true.
  static Future<bool> requestPermission() async {
    if (!supported) return false;
    await _init();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  static Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelName,
  }) async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(_id);
    final now = tz.TZDateTime.now(tz.local);
    var at = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      _id,
      title,
      body,
      at,
      NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', channelName),
      ),
      // Aniq soat-daqiqa shart emas: tizim batareyani tejab, bir necha daqiqa oldin-keyin ko'rsatishi mumkin.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancel() async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(_id);
  }
}
