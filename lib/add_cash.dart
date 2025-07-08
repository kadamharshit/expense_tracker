import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/expense_database.dart';

class AddCash extends StatefulWidget {
  const AddCash({super.key});

  @override
  State<AddCash> createState() => _AddCashState();
}

class _AddCashState extends State<AddCash> {

  final _formKey = GlobalKey<FormState>();
  final _cashAmountController = TextEditingController();
  String? _selectedDate;
  String? _mode = 'Cash';

  final List<Map<String, TextEditingController>> _bankInputs =[];

  @override
  void initState() {
    super.initState();
    _bankInputs.add({
      'bank': TextEditingController(),
      'amount': TextEditingController(),
    });
  }
  Future <void> _pickDate() async {
    final picked = await showDatePicker(context: context,
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
  void _addBankField() {
    setState(() {
      _bankInputs.add({
        'bank':TextEditingController(),
        'amount': TextEditingController(),
      });
    });
  }
Future<void> _saveBudget() async {
  if (_formKey.currentState!.validate()) {
    final date = _selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (_mode == 'Cash') {
      final entry = {
        'date': date,
        'amount': double.tryParse(_cashAmountController.text) ?? 0.0,
        'mode': 'Cash',
      };
      await DatabaseHelper.instance.insertBudget(entry);
    } else {
      for (var bankInput in _bankInputs) {
        final entry = {
          'date': date,
          'amount': double.tryParse(bankInput['amount']!.text) ?? 0.0,
          'mode': 'Online',
        };
        await DatabaseHelper.instance.insertBudget(entry);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Budget entry saved!")),
    );
    Navigator.pushReplacementNamed(context, '/home');
  }
}


  Widget _buildOnlineBankField() {
    return Column(
      children: [
        ..._bankInputs.asMap().entries.map((entry){
          final index = entry.key;
          final controllers = entry.value;
          return Column(
            children: [
              TextFormField(
                controller: controllers['bank'],
                decoration: const InputDecoration(labelText: 'Bank Name (optional)'),
              ),
              TextFormField(
                controller: controllers['amount'],
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) =>val == null || val.isEmpty ? 'Enter Amount': null,
              ),
              const Divider(),
            ],
          );
        }),
        ElevatedButton.icon(
          onPressed: _addBankField,
          icon: Icon(Icons.add),
          label: const Text('Add Another Bank'),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
      ),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextButton.icon(
              onPressed:_pickDate ,
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate ?? 'Select Date'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
            value: _mode,
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Online',child: Text('Online')),
            ],
            onChanged: (value){
              setState(() {
                _mode = value!;
              });
            },
            decoration: const InputDecoration(labelText: 'Budget Mode'),
            ),
            SizedBox(height: 16),

            //Mode specific UI
            if(_mode == 'Cash') ...[
              TextFormField(
                controller: _cashAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cash Amount'),
                validator: (val) => val == null || val.isEmpty ? 'Enter amount': null,
              ),
              ] else ...[
                _buildOnlineBankField(),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBudget,
                child: const Text('Save Budget'),
              ),
          ],
        ),
      ),
      ),
    );
  }
}