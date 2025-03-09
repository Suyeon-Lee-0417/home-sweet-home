import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/screens/create-room-screen.dart';
import 'package:pineapple/screens/join-room-screen.dart';
import 'package:pineapple/screens/login-screen.dart';
import 'package:pineapple/screens/nav-screen.dart';
import 'package:pineapple/screens/room-joined-result.dart';
import 'package:pineapple/screens/sign-up-screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

    // ✅ Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("💬 Message received in background: ${message.notification?.title}");
}


void requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("✅ Notifications Allowed");
  } else {
    print("❌ Notifications Denied");
  }
}

void getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM Token: $token");
}
  
void setupFirebaseListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 New notification: ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔄 App opened by clicking the notification!");
  });
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService(); // ✅ Initialize API Service

  MyApp({super.key});





  @override
  Widget build(BuildContext context) {
    getToken();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(apiService: apiService), // Pass API service
      routes: {
        '/main-screen': (context) => Navigation(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
       '/create-room': (context) => CreateRoomScreen(),
       '/join-room': (context) => JoinRoomScreen(),
       
      },
        onGenerateRoute: (settings) {
        if (settings.name == '/room-joined') {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => RoomJoinedScreen(roomName: args),
          );
        }
        return null; // Returns null if no route matches, defaulting to `routes`
      },
    );
  }
}

// ✅ Check authentication and initialize API
class AuthCheck extends StatelessWidget {
  final ApiService apiService; // Accept API service
  AuthCheck({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Loading state
        }
        if (snapshot.hasData) {
          return Navigation(); // User is logged in
        } else {
          return LoginScreen(); // User is not logged in
        }
      },
    );
  }
}