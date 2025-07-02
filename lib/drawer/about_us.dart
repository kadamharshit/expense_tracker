import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget{
  const AboutUs ({super.key});

  @override  

  Widget build (BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: const Text("About Us"),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0),
      child: const Text("Welcome to Expense Tracker App. Here you can manager your expense and make record of you spendings. The expense can be entered by Two ways: By receipt or manual.If any queries, email on: expensetracker@gmail.com"),),
    );
  }
}