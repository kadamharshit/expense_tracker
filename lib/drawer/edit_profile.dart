import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final FlutterSecureStorage storage = FlutterSecureStorage();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    nameController.text = await storage.read(key: 'name')?? '';
    mobileController.text = await storage.read(key: 'mobile') ?? '';
    emailController.text = await storage.read(key: 'email') ?? '';
    dobController.text = await storage.read(key: 'dob') ?? '';
  }

  Future<void> edit() async {
    await storage.write(key: 'name', value: nameController.text);
    await storage.write(key: 'mobile', value: mobileController.text);
    await storage.write(key: 'email', value: emailController.text);
    await storage.write(key: 'dob', value: dobController.text);
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: 
      Column(
          children: [
            TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Name"),),
            TextFormField(controller: mobileController, decoration: InputDecoration(labelText: "Mobile"),),
            TextFormField(controller: emailController, decoration: InputDecoration(labelText: "Email"),),
            TextFormField(controller: dobController, decoration: InputDecoration(labelText: "DOB"),),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async 
              {
                await edit();
                Navigator.pop(context);
              },
              child: const Text("Save")),
          ],
      )
      );
  }
}