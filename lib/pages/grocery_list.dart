import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/pages/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  //To navigate to add item page
  void _addItem() async {
    //this function is asynchronous, .push yields a Future which holds the data which may return by the new screen (new item)
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(
            builder: (context) =>
                const NewItem())); //some data will be eventually yielded.
    //stateless widgets dont come w context so we change to be stateful

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  //Remove items from list
  void _removeItem(item) {
    _groceryItems.remove(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Groceries",
          textAlign: TextAlign.left,
        ),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: _groceryItems.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(_groceryItems[index]),
                  background: Container(
                    //using out theme here to get the related error
                    color: Theme.of(context).colorScheme.error,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onDismissed: (direction) {
                    _removeItem(_groceryItems[index]);
                  },
                  child: ListTile(
                    title: Text(_groceryItems[index].name),
                    leading: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: _groceryItems[index].category.color),
                    ),
                    trailing: Text(_groceryItems[index].quantity.toString()),
                  ),
                );
              })
          : const Center(child: Text("Your list is empty.")),
    );
  }
}
