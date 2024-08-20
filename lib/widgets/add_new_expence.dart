import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';

class AddNEewExpences extends StatefulWidget {
  final void Function(ExpenceModel expence) onAddExpence;
  const AddNEewExpences({super.key, required this.onAddExpence});

  @override
  State<AddNEewExpences> createState() => _AddNEewExpencesState();
}

class _AddNEewExpencesState extends State<AddNEewExpences> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategor = Category.leasure;

  //date variables
  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  DateTime _selectedDate = DateTime.now();

  //date picker
  Future<void> _openDateModal() async {
    try {
      //show the date model then srtore the user  selected date
      final pickDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate);

      setState(() {
        _selectedDate = pickDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void _showDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter valid Data"),
          content: const Text(
              "Please enter valid data for the title and amount hear the title cant be empty and the amount cant be less than zero"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  //handel form submit
  void _handelFromSubmit() {
    //form validation
    //convert the amount in to a double
    try {
      //final amountText = _amountController.text.trim();
      final userAmount = double.parse(_amountController.text.trim());
      if (userAmount <= 0 || _titleController.text.trim().isEmpty) {
        _showDialogBox();
      } else {
        //create the new expence
        ExpenceModel newExpence = ExpenceModel(
            amount: userAmount,
            date: _selectedDate,
            title: _titleController.text.trim(),
            category: _selectedCategor);
        widget.onAddExpence(newExpence);
        Navigator.pop(context);
        //print(Text("submit done"));
      }

      // Use the parsed amount
    } catch (e) {
      _showDialogBox();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Column(
        children: [
          //titel text feild
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expence title",
              label: Text("Tile"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(famattedDate.format(_selectedDate)),
                  IconButton(
                    onPressed: _openDateModal,
                    icon: const Icon(Icons.date_range_outlined),
                  )
                ],
              ))
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategor,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategor = value!;
                  });
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.redAccent),
                      ),
                      child: const Text("Close"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: _handelFromSubmit,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 9, 244, 162)),
                      ),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
