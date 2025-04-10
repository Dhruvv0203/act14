import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();

    // Get FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _fcmToken = token;
      });
      print("FCM Token: $_fcmToken");
    });

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final String type = message.data['type'] ?? 'regular';
      final bool isImportant = type == 'important';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(isImportant ? '🚨 Important' : '🔔 Notification'),
          content: Text(message.notification?.body ?? 'No content'),
          backgroundColor: isImportant ? Colors.red[100] : Colors.blue[100],
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    });

    // Tapped message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message clicked: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM ClassActivity14'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          _fcmToken != null
              ? 'FCM Token:\n$_fcmToken\n\nUse this token to send test messages from Firebase Console.'
              : 'Fetching FCM token...',
        ),
      ),
    );
  }
}
