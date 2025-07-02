import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/drawer/expense_tracker.dart';
import 'package:expense_tracker/drawer/profiles.dart';
import 'package:expense_tracker/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:expense_tracker/expense_database.dart';
import 'package:intl/intl.dart';
import 'drawer/about_us.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FlutterSecureStorage storage = FlutterSecureStorage();
  double _totalExpense = 0.0;
  String _username = '';
  String _useremail = '';

  @override 
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadTotalExpense();
  }
  Future<void> _loadTotalExpense() async{
    final expenses = await DatabaseHelper.instance.getExpenses();
    final total = expenses.fold(0.0,(sum,item)=>sum + (item['total']as double));
    setState(() {
      _totalExpense = total;
    });
  }
  String currentMonthYear() {
    final now = DateTime.now();
    return DateFormat("MMMM yyyy").format(now);
  }

  Future <void> _loadUserInfo () async {
    String? name = await storage.read(key: 'name');
    String? email = await storage.read(key: 'email');

  setState(() {
    _username = name ?? 'User';
    _useremail = email ?? 'example@gmail.com';
  });
  }
  @override  
  Widget build (BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(16),
              child: ListTile(
              title: Text("Total Expense ${currentMonthYear()}"),
              subtitle: Text("₹ ${_totalExpense.toStringAsFixed(2)}"),
              leading: Icon(Icons.currency_rupee),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea( 
          child : ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlue),
              accountName: Text(_username),
              accountEmail: Text(_useremail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 165, 255, 137),
              ),
              currentAccountPictureSize: Size.square(50))
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Profiles()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text("Expense Tracker"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseTracker()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                showDialog(context: context, builder: (ctx)=> AlertDialog(
                  title: const Text("Sign Out"),
                  content: const Text("Do You Want to Sign Out?"),
                  actions: <Widget>[
                    TextButton(onPressed: (){
                      Navigator.pop(ctx);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    }, child: const Text("Yes")),
                    TextButton(
                      
                      onPressed: () {
                        Navigator.pop(ctx);
                      }, child: const Text("No")),
                  ],
                  
                ));
              },
            ),
          ],
        ),
      
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense()));
      },
      child: Icon(Icons.add),
       tooltip: "Add Expense",
      ),
      
  );
  }
}
