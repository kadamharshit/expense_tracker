import 'package:flutter/material.dart';
import "package:flutter_secure_storage/flutter_secure_storage.dart";
// import 'home_screen.dart';
// import 'login_screen.dart';
// import 'main.dart';

class CreateAccountScreen extends StatefulWidget{
  const CreateAccountScreen ({super.key});

  @override  
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>{
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future <void> saveUser() async {
    String? existingUser = await storage.read(key: 'username');

    if (existingUser == usernameController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Username already exists")));
      return;
    }
    await storage.write(key: 'name', value: nameController.text);
    await storage.write(key: 'mobile', value: mobileController.text);
    await storage.write(key: 'email', value: mobileController.text);
    await storage.write(key: 'username',value: usernameController.text);
    await storage.write(key: 'password', value: passwordController.text);
    await storage.write(key: 'dob',value: dobController.text);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created!")));

    Navigator.pop(context); //Go back to Login
  }

  @override  
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: 
      Padding(padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: mobileController, decoration: const InputDecoration(labelText: "Mobile")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            TextField(controller: dobController, decoration: const InputDecoration(labelText: "DOB (optional)")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveUser,
              child: const Text("Save"))
          ],
        ),
      )),
    );
  }
}