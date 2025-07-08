import 'package:flutter/material.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How To Use'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          '''
📖 How to Use the Expense Tracker App

🧾 1. Add an Expense
You can track your spending in two ways:
• Add Manually: Enter the date, shop name, category, items (name, quantity, amount), and how you paid (Cash or Online).
• Add via Receipt: Upload or capture an image of a bill and the app will extract key details automatically using OCR.

💰 2. Manage Your Budget
Go to "Manage Budget" from the drawer:
• Cash: Enter cash-in-hand amount.
• Online: Add money available in different bank or UPI accounts.

🔄 3. Auto-Budget Deduction
When you add an expense, the app checks how it was paid and reduces the corresponding (Cash or Online) budget.

📊 4. View Dashboard
Home screen shows:
• Total Expense for the current month
• Total Budget available (Cash + Online combined)

🧍‍♂️ 5. My Profile
View and edit your name, mobile number, and email from the "My Profile" page in the drawer.

🔐 6. Login and Security
Your credentials are securely stored. Once logged in, you stay signed in unless you sign out.

📤 7. Sign Out
Use the "Sign Out" option in the drawer. You’ll be asked to confirm before logging out.

🙋 Need Help?
For support or feedback, contact: harshit.expensetracker@gmail.com
          ''',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
