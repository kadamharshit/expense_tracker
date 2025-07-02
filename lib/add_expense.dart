import 'package:expense_tracker/receipt/add_manual.dart';
import 'package:flutter/material.dart';
//import 'home_screen.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'receipt/add_reciept.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(70),
        child: Center(
          child: Column(
            children: [
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.all(50),
              //     child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddReceipt()));
              //     },
              //     style: ElevatedButton.styleFrom(
              //       minimumSize: Size(200, 60),
              //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              //       textStyle: TextStyle(fontSize: 18),
              //     ),
              //     child: Text("Add Receipt")
              //     ),
              //   ),
              // ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> AddManualExpense()));            
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 60),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Add Manual Receipt"),),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}