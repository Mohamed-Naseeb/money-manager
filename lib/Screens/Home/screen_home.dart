import 'package:flutter/material.dart';
import 'package:moneyman/Screens/Category/category_add_popup.dart';
import 'package:moneyman/Screens/Category/screen_category.dart';
import 'package:moneyman/Screens/Home/widgets/bottom_navigation.dart';
import 'package:moneyman/Screens/Transactions/screen_transaction.dart';
import 'package:moneyman/Screens/Transactions/transaction_add.dart';

class ScreenHome extends StatelessWidget {
   const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  
  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: const Text("Moneyman"),),
      body: SafeArea(child: ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, _) {
          return _pages[updatedIndex];
        },
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if(ScreenHome.selectedIndexNotifier.value == 0){
          print("add transaction");
          Navigator.of(context).pushNamed(AddTransaction.routeName);
        }else{
          print("add category");
          showCategoryAddPopup(context);
        }

      },
      child: const Icon(Icons.add),
      ),

      bottomNavigationBar: const MoneymanBottomNav(),
    );
  }
}