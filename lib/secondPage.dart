import 'package:flutter/material.dart';
import 'package:in_class/data.dart'; // Import the DataRepository

class secondPage extends StatefulWidget {
  const secondPage({super.key});

  @override
  State<secondPage> createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  var words = <String>[" Item 1", " Item 2"];
  final TextEditingController _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${DataRepository.getLoginName()}!"),
            const SizedBox(height: 16),
            Text("Age: ${DataRepository.getAge()}"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: InputDecoration(hintText: "Type here!"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_input.value.text.isNotEmpty) {
                        setState(() {
                          words.add(_input.value.text);
                          _input.text = "";
                        });
                      } else {
                        const snackBar =
                            SnackBar(content: Text("Please Input something!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text("Add Item"))
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, rowNum) {
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete?"),
                                content: Text(
                                    "Are you sure you want to delete the row?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          words.removeAt(rowNum);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text("Yes")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text("No"))
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Row Number: $rowNum"),
                          Text(words[rowNum])
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
