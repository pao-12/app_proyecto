import 'package:flutter/material.dart';
// Paquete para manejar notificaciones locales
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Carga todas las zonas horarias disponibles
import 'package:timezone/data/latest_all.dart' as tz;
// Manejo de fechas y horas con zonas horarias
import 'package:timezone/timezone.dart' as tz;

// Pantalla de configuración de notificaciones
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  // Instancia principal para manejar notificaciones
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Cuando se abre la pantalla, inicializa las notificaciones
    initNotifications();
  }

  // ===============================
  // Inicializa el sistema de notificaciones
  // ===============================
  void initNotifications() async {
    // Configuración inicial solo para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Ajustes generales de inicialización
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    // Inicializa el plugin de notificaciones
    await notificationsPlugin.initialize(settings);

    // Inicializa el uso de zonas horarias para notificaciones programadas
    tz.initializeTimeZones();
  }

  // ===============================
  // Muestra una notificación inmediata
  // ===============================
  Future<void> showNotification(String title, String body) async {

    // Configuración del canal de notificación
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_1', // ID del canal
      'Recordatorios de comida', // Nombre visible del canal
      importance: Importance.max,
      priority: Priority.high,
    );

    // Configuración final de la notificación
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Muestra la notificación inmediatamente
    await notificationsPlugin.show(
      0,       // ID de la notificación
      title,   // Título
      body,    // Mensaje
      notificationDetails,
    );
  }

  // ===============================
  // Programa la notificación de COMIDA a las 12:00 PM
  // ===============================
  Future<void> scheduleLunchNotification() async {

    // Configuración del canal de la notificación programada
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_comida', // ID del canal
      'Recordatorio de comida', // Nombre visible del canal
      importance: Importance.max,
      priority: Priority.high,
    );

    // Configuración final
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    // Obtiene la fecha y hora actuales con zona horaria
    final now = tz.TZDateTime.now(tz.local);

    // Crea la fecha y hora para las 12:00 PM
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      12, // Hora (12 PM)
      0,  // Minutos
      0,  // Segundos
    );

    // Si hoy ya pasó las 12:00 PM, agenda para mañana
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Programa la notificación diaria
    await notificationsPlugin.zonedSchedule(
      1, // ID de la notificación
      'Hora de comer ', // Título
      'Recuerda registrar tu comida en la app', // Mensaje
      scheduledDate,
      details,
      androidAllowWhileIdle: true, // Permite que funcione incluso en reposo
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repetir diariamente
    );
  }

  // ===============================
  // Interfaz de la pantalla
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Título de la pantalla
              const Text(
                'Configura tus recordatorios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),

              // Botón para notificación inmediata de Desayuno
              ElevatedButton(
                onPressed: () {
                  showNotification(
                    'Desayuno ',
                    'Recuerda registrar tu desayuno',
                  );
                },
                child: const Text('Notificación de Desayuno'),
              ),

              const SizedBox(height: 10),

              // Botón para activar notificación diaria a las 12:00 PM
              ElevatedButton(
                onPressed: () {
                  scheduleLunchNotification();
                },
                child: const Text('Activar notificación de Comida (12:00 PM)'),
              ),

              const SizedBox(height: 10),

              // Botón para notificación inmediata de Cena
              ElevatedButton(
                onPressed: () {
                  showNotification(
                    'Cena ',
                    'Recuerda registrar tu cena',
                  );
                },
                child: const Text('Notificación de Cena'),
              ),

              const SizedBox(height: 10),

              // Botón para notificación inmediata de Agua
              ElevatedButton(
                onPressed: () {
                  showNotification(
                    'Agua ',
                    'Recuerda tomar agua',
                  );
                },
                child: const Text('Notificación de Agua'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
