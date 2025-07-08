import 'package:expense_tracker/drawer/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

    final FlutterSecureStorage storage = FlutterSecureStorage();
    String _name = '';
    String _mobile = '';
    String _email = '';
    String _dob = '';

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  void loadProfileData () async {
    String? name = await storage.read(key: 'name');
    String? mobile = await storage.read(key: 'mobile');
    String? email = await storage.read(key: 'email');
    String? dob = await storage.read(key: 'dob');

    setState(() {
      _name = name ?? '';
      _mobile = mobile ?? '';
      _email = email ?? '';
      _dob = dob ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Profiles"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
                children: [
                    Text("Name: $_name", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text("Mobile: $_mobile", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text("Email: $_email", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text("DOB: $_dob", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfile()),
                            ).then((_){
                                loadProfileData();
                            });
                        }, child: const Text("Edit Profile")),
                ],
                
            ),
          ),
        )
        
    );
  }
}