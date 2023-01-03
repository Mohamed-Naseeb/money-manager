import 'package:flutter/material.dart';
import 'package:moneyman/db/category/category_db.dart';
import 'package:moneyman/db/transaction/transaction_db.dart';
import 'package:moneyman/model/category/model_category.dart';
import 'package:moneyman/model/transaction/model_transaction.dart';

class AddTransaction extends StatefulWidget {
  static const routeName = "add_transaction";

  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedRadioValue;
  String? _dropdownValue;
  CategoryModel? _selectedCategory;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedRadioValue = CategoryType.income;
    super.initState();
  }

  /*
  purpose
  date
  amount
  Income/Expense
  Category Type
  
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //purpose
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: "Purpose"),
            ),
            //amount
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Amount"),
            ),
            //date
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );

                if (_selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? "Select Date"
                  : _selectedDate.toString()),
            ),
            //Income and expense
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedRadioValue,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRadioValue = newValue;
                          _dropdownValue = null;
                        });
                      },
                    ),
                    const Text("Income"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedRadioValue,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRadioValue = newValue;
                          _dropdownValue = null;
                        });
                      },
                    ),
                    const Text("Expense"),
                  ],
                ),
              ],
            ),
            //Category type
            DropdownButton<String>(
              hint: const Text("Select Category"),
              value: _dropdownValue,
              items: (_selectedRadioValue == CategoryType.income
                      ? CategoryDB.instance.incomeCategoryListListener
                      : CategoryDB.instance.expenseCategoryListListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    _selectedCategory = e;
                  },
                );
              }).toList(),
              //     _radioValue == CategoryType.income ?
              //       CategoryDB.instance.incomeCategoryListListener.value.map((e) {
              //   return DropdownMenuItem(value: e.id, child: Text(e.name));
              // }).toList():
              // CategoryDB.instance.expenseCategoryListListener.value.map((e) {
              //   return DropdownMenuItem(value: e.id, child: Text(e.name));
              // }).toList(),

              onChanged: (value) {
                setState(() {
                  _dropdownValue = value;
                });
              },
            ),
            //Submit Button
            ElevatedButton(onPressed: () {
              addTransaction();
              
            }, child: const Text("Submit"))
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purpose = _purposeTextEditingController.text;
    final _amount = _amountTextEditingController.text;

    if (_purpose.isEmpty) {
      return;
    }
    if (_amount.isEmpty) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedRadioValue == null) {
      return;
    }

    final _parsed = double.tryParse(_amount);
    if (_parsed == null) {
      return;
    }
    if(_selectedCategory == null){
      return;
    }

    final model = TransactionModel(
      purpose: _purpose,
      amount: _parsed,
      date: _selectedDate!,
      type: _selectedRadioValue!,
      category: _selectedCategory!,
    );

    await TransactionDB.instance.insertTransaction(model);
    Navigator.of(context).pop();
  }
}
