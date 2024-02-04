import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; //bundle all content from this package into http object.

import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<
      FormState>(); //creates global key object, used as value for key. gives us access to widget its connect to.
  var _enteredName = ' ';
  int _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      //execute all validtor functions, return true if ALL valid or false;
      _formKey.currentState!
          .save(); //save method, we can invoke onSave on each widget and save values in a var.
      
      //sending requests to backend

      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category:
              _selectedCategory)); //we can pass data through the pop navigator pop method which closes the screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        //the FORM WIDGET
        child: Form(
          //validate all the validators (execute them)
          key: _formKey, //global keys generally with forms.
          child: Column(children: [
            TextFormField(
              maxLength: 50, //nothing longer than 50 char
              decoration: const InputDecoration(
                label: Text('Name'),
              ),

              //will return this invalid text if any validation fails for this field
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50 characters!';
                }
                // No Errors
                return null;
              },
              onSaved: (newValue) {
                _enteredName =
                    newValue!; //Entered input is saved into variable, because when saving and calling saved item function we access the .save method.
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Quantity"),
                    ),
                    //initial value displayed in the field.
                    initialValue: _enteredQuantity.toString(),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Enter a valid positive number!';
                      }
                      // No Errors
                      return null;
                    },
                    onSaved: (newValue) =>
                        _enteredQuantity = int.parse(newValue!),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        //in list for loop
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value:
                                  category.value, //object with color and title
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(category.value
                                      .category), //access the title of category
                                ],
                              )) //entries turns map into iterable so we can loop thru
                      ],
                      onChanged: (value) {
                        _selectedCategory = value!;
                      }),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      //To Reset the form
                      _formKey.currentState!.reset(); //Reset ALL values
                    },
                    child: const Text("Reset")),
                ElevatedButton(
                    onPressed: _saveItem, child: const Text("Add Item")),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
