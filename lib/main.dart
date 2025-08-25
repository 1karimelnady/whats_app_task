import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_task/core/services/auth_services.dart';
import 'package:whats_app_task/core/services/chat_services.dart';
import 'package:whats_app_task/core/services/story_services.dart';
import 'package:whats_app_task/core/utils/themes.dart';
import 'package:whats_app_task/features/auth/screen/login_screen.dart';
import 'package:whats_app_task/features/home/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:whats_app_task/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ChatService>(create: (_) => ChatService()),
        Provider<StoryService>(create: (_) => StoryService()),
      ],
      child: MaterialApp(
        title: 'WhatsApp Clone',
        theme: WhatsAppThemes.lightTheme,
        darkTheme: WhatsAppThemes.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<firebase_auth.User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
