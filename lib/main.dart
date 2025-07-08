import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'add_cash.dart'; // import this if not done already
// import other screens if needed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    return username != null && password != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/add_cash': (context) => const AddCash(),
        // Add more named routes here if needed
      },
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data == true
                ? const HomeScreen()
                : const LoginScreen();
          }
        },
      ),
    );
  }
}
