import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneyman/db/category/category_db.dart';
import 'package:moneyman/db/transaction/transaction_db.dart';
import 'package:moneyman/model/category/model_category.dart';
import 'package:moneyman/model/transaction/model_transaction.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();

    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext context, List<TransactionModel> value, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(3.0),
          itemBuilder: (context, index) {
            final transaction = value[index];
            return Slidable(
              key: Key(transaction.id!),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      TransactionDB.instance.deleteTransaction(transaction.id!);
                    },
                    label: "Delete",
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    // ignore: sort_child_properties_last
                    child: Text(
                      parseDate(transaction.date),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: (transaction.type == CategoryType.income
                        ? Colors.greenAccent
                        : Colors.redAccent),
                  ),
                  title: Text("Amount:${transaction.amount}"),
                  subtitle: Text("purpose: ${transaction.category.name}"),
                  trailing: IconButton(
                    onPressed: () {
                      TransactionDB.instance.deleteTransaction(transaction.id!);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 2);
          },
          itemCount: value.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _dateSplit = _date.split(" ");
    return '${_dateSplit.last}\n${_dateSplit.first}';
  }
}
