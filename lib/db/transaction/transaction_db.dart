import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneyman/model/transaction/model_transaction.dart';

const TRANSACTION_DB_NAME = "transaction-database";

abstract class TransactionDbFunctions {
  Future<void> insertTransaction(TransactionModel value);
  Future<List<TransactionModel>> getTransaction();
}


class TransactionDB implements TransactionDbFunctions{

  TransactionDB._internal();

  static final TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

 ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);

  @override
  Future<void> insertTransaction (TransactionModel value)async{
     final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
     await _transactionDB.put(value.id, value);
     refreshUI();
  }
  
  @override
  Future<List<TransactionModel>> getTransaction() async {
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return  _transactionDB.values.toList();
    
  }

  Future<void> refreshUI() async {
    final _allTransaction = await getTransaction();
    _allTransaction.sort((first, second) => second.date.compareTo(first.date) );
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_allTransaction);
    // await Future.forEach(_allTransaction, (transaction) {
    //   transactionListNotifier.value.add(transaction);
    // });
    transactionListNotifier.notifyListeners();
  }

  Future<void> deleteTransaction(String id) async{
    final _transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDB.delete(id);
    refreshUI();
  }


}