import 'package:expense_tracker/login_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
// import 'create_account_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future <bool> isLoggedIn() async {

    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    return username != null && password != null;
  }
  @override  
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expense Tracker',
        home: FutureBuilder(
          future: isLoggedIn(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data == true ? const HomeScreen() : const LoginScreen();
            }
          }),
    );
  }

}