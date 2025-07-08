import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/expense_database.dart';

class AddManualExpense extends StatefulWidget {
  const AddManualExpense({super.key});

  @override
  State<AddManualExpense> createState() => _AddManualExpenseState();
}

class _AddManualExpenseState extends State<AddManualExpense> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedDate;
  final _shopController = TextEditingController();
  String _selectedCategory = 'Grocery';
  String _selectedPaymentMode = 'Cash';

  List<Map<String, String>> itemInputs = [];
  double total = 0.0;

  final List<String> _categories = [
    'Grocery',
    'Travel',
    'Food',
    'Medical',
    'Bills',
    'Other'
  ];

  final List<String> _paymentModes = ['Cash', 'Online'];

  @override
  void initState() {
    super.initState();
    itemInputs.add({});
  }

  void _addItem() {
    setState(() {
      itemInputs.add({});
    });
  }

  void _updateTotal() {
    double sum = 0.0;
    for (var item in itemInputs) {
      final amt = double.tryParse(item['amount'] ?? '0') ?? 0;
      sum += amt;
    }
    setState(() {
      total = sum;
    });
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String date =
          _selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

      final expense = {
        'date': date,
        'shop': _shopController.text,
        'category': _selectedCategory,
        'items': itemInputs.map((item) => item.values.join(' | ')).join('\n'),
        'total': total,
      };

      // Save expense
      await DatabaseHelper.instance.insertExpense(expense);

      // Deduct from budget based on payment mode
      final deduction = {
        'date': date,
        'amount': -total,
        'mode': _selectedPaymentMode,
      };
      await DatabaseHelper.instance.insertBudget(deduction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Saved & Budget Updated!")),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _buildItemFields(int index) {
    final item = itemInputs[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedCategory == 'Travel') ...[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mode'),
            onSaved: (val) => item['mode'] = val ?? '',
            initialValue: item['mode'],
            validator: (val) => val == null || val.isEmpty ? 'Enter mode' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Start'),
            onSaved: (val) => item['start'] = val ?? '',
            initialValue: item['start'],
            validator: (val) => val == null || val.isEmpty ? 'Enter start' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Destination'),
            onSaved: (val) => item['destination'] = val ?? '',
            initialValue: item['destination'],
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter destination' : null,
          ),
        ] else ...[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Item Name'),
            onSaved: (val) => item['name'] = val ?? '',
            initialValue: item['name'],
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter item name' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Quantity'),
            onSaved: (val) => item['qty'] = val ?? '',
            initialValue: item['qty'],
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter quantity' : null,
          ),
        ],
        TextFormField(
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            item['amount'] = val;
            _updateTotal();
          },
          onSaved: (val) => item['amount'] = val ?? '0',
          initialValue: item['amount'],
          validator: (val) =>
              val == null || val.isEmpty ? 'Enter amount' : null,
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Manual Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(_selectedDate ?? 'Select Date'),
              ),
              TextFormField(
                controller: _shopController,
                decoration:
                    const InputDecoration(labelText: 'Shop Name / Type'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter shop name' : null,
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    itemInputs = [{}]; // reset inputs on category change
                    total = 0.0;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              DropdownButtonFormField(
                value: _selectedPaymentMode,
                items: _paymentModes
                    .map((mode) =>
                        DropdownMenuItem(value: mode, child: Text(mode)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMode = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Paid By'),
              ),
              const SizedBox(height: 16),
              const Text("Items",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...List.generate(
                  itemInputs.length, (index) => _buildItemFields(index)),
              Text("Total: ₹${total.toStringAsFixed(2)}"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text("Add Another Item"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
