import 'package:flutter/material.dart';
import 'package:expense_tracker/expense_database.dart';

class BudgetTracker extends StatefulWidget {
  const BudgetTracker({super.key});

  @override
  State<BudgetTracker> createState() => _BudgetTrackerState();
}

class _BudgetTrackerState extends State<BudgetTracker> {
  late Future<List<Map<String, dynamic>>> _budgetList = Future.value([]); // ✅ initialize to avoid error
  List<Map<String, dynamic>> _filteredBudgets = [];
  List<String> _availableMonths = [];
  String _selectedMonth = '';

  @override
  void initState() {
    super.initState();
    _initializeMonthList();
  }

  void _initializeMonthList() async {
    final allBudgets = await DatabaseHelper.instance.getBudget();
    final monthSet = <String>{};

    for (var entry in allBudgets) {
      final date = entry['date'];
      if (date.length >= 7) {
        monthSet.add(date.substring(0, 7)); // e.g. "2025-07"
      }
    }

    final sortedMonths = monthSet.toList()..sort((a, b) => b.compareTo(a));

    setState(() {
      _availableMonths = sortedMonths;
      _selectedMonth = sortedMonths.isNotEmpty
          ? sortedMonths.first
          : "${DateTime.now().year.toString().padLeft(4, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}";
    });

    _loadBudgetsForMonth(_selectedMonth);
  }

  void _loadBudgetsForMonth(String month) async {
    final allBudgets = await DatabaseHelper.instance.getBudget();
    final filtered = allBudgets.where((entry) {
      final date = entry['date'];
      return date.startsWith(month);
    }).toList();

    setState(() {
      _filteredBudgets = filtered;
      _budgetList = Future.value(filtered); // ✅ assign here
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatMonthLabel(String monthYear) {
    final parts = monthYear.split('-');
    final year = parts[0];
    final month = int.parse(parts[1]);
    return "${_getMonthName(month)} $year";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Tracker")),
      body: Column(
        children: [
          if (_availableMonths.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButton<String>(
                value: _selectedMonth,
                isExpanded: true,
                items: _availableMonths.map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(_formatMonthLabel(month)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMonth = value;
                    });
                    _loadBudgetsForMonth(value);
                  }
                },
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _budgetList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No budget entries recorded."));
                }

                final budgets = snapshot.data!;
                double total = budgets.fold(0.0, (sum, item) => sum + (item['amount'] as double));

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      color: Colors.teal,
                      child: Text(
                        "Total Budget – ${_formatMonthLabel(_selectedMonth)}: ₹${total.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          final item = budgets[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            child: ListTile(
                              leading: Icon(
                                item['mode'] == 'Cash'
                                    ? Icons.money
                                    : Icons.account_balance_wallet,
                                color: item['mode'] == 'Cash' ? Colors.green : Colors.blue,
                              ),
                              title: Text("₹${(item['amount'] as double).toStringAsFixed(2)}"),
                              subtitle: Text("Date: ${item['date']} • Mode: ${item['mode']}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
