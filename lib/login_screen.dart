import 'package:expense_tracker/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';
// import 'main.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen ({super.key});

  @override 
  
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();


  Future <void> login() async {
    String? storedUsername = await storage.read(key: 'username');
    String? storedPassword = await storage.read(key: 'password');

    if (storedUsername == usernameController.text && storedPassword == passwordController.text) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    } 
  }

  @override  

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: login,
              child: const Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> const CreateAccountScreen()));
              },
              child: const Text("Create Account"),
              )
          ],
        ),),
    );
  }
}