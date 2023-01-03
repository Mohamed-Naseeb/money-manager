
import 'package:flutter/material.dart';
import 'package:moneyman/db/category/category_db.dart';
import 'package:moneyman/model/category/model_category.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:CategoryDB().incomeCategoryListListener,
        builder: (BuildContext context,List<CategoryModel> newList,Widget? _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final category = newList[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDB.instance.deleteCategory(category.id);
                        
                      }, icon: const Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 4,
              );
            },
            itemCount: newList.length,
          );
        });
  }
}
