import 'package:flutter/material.dart';
import 'package:moneyman/Screens/Home/screen_home.dart';

class MoneymanBottomNav extends StatelessWidget {
  const MoneymanBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext context,int updatedIndex,_) {
        return BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[600],
        currentIndex: updatedIndex,
        onTap: (newindex) {
          ScreenHome.selectedIndexNotifier.value = newindex;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: "Transaction"),
          BottomNavigationBarItem(icon: Icon(Icons.category),label: "Category")
        ]);
      },
      
    );
  }
}
