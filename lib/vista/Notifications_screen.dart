import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  // ===== Inicializar notificaciones =====
  void initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);

    tz.initializeTimeZones();
  }

  // ===== Notificación inmediata =====
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_1',
      'Recordatorios generales',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }

  // ===== Notificación programada a las 12:00 PM =====
  Future<void> scheduleLunchNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_comida',
      'Recordatorio de comida',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      12,
      0,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      1,
      'Hora de comer 🍽️',
      'Recuerda registrar tu comida en la app',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // YA NO ES MORADO
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                'Configura tus recordatorios',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),

              _buildNotificationButton(
                icon: Icons.breakfast_dining,
                text: 'Desayuno',
                color: Colors.orange,
                onPressed: () {
                  showNotification(
                    'Desayuno',
                    'Recuerda registrar tu desayuno',
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildNotificationButton(
                icon: Icons.lunch_dining,
                text: 'Comida (12:00 PM)',
                color: Colors.green,
                onPressed: () {
                  scheduleLunchNotification();
                },
              ),

              const SizedBox(height: 12),

              _buildNotificationButton(
                icon: Icons.dinner_dining,
                text: 'Cena',
                color: Colors.deepPurple,
                onPressed: () {
                  showNotification(
                    'Cena',
                    'Recuerda registrar tu cena',
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildNotificationButton(
                icon: Icons.water_drop,
                text: 'Tomar Agua',
                color: Colors.blue,
                onPressed: () {
                  showNotification(
                    'Agua',
                    'Recuerda tomar agua',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Botón personalizado =====
  Widget _buildNotificationButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

