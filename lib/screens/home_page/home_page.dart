import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController addTextController = TextEditingController();
    TextEditingController updateTextController = TextEditingController();

    var box = Hive.box('box');

// Add Data
    Future<void> addData() async {
      int key = box.length;

      if (addTextController.text != '') {
        key++;
        setState(() {
          box.put(key, addTextController.text);
        });
        addTextController.clear();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Write Something to Add');
      }
    }

    // Edit Data
    void editData(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Data'),
              content: TextFormField(
                controller: updateTextController,
                autofocus: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                    hintText: box.getAt(index),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (updateTextController.text != '') {
                        setState(() {
                          box.putAt(index, updateTextController.text);
                        });
                        Navigator.pop(context);
                        updateTextController.clear();
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Write Something to Update');
                      }
                    },
                    child: const Text('Update'))
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("HIVE in Flutter"),
      ),

      body: box.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.primaries[index % Colors.primaries.length],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(box.getAt(index)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            //Edit Button
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editData(index);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),

                              //delete Button
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      box.deleteAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Add Data',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onEditingComplete: addData,
                        autofocus: true,
                        controller: addTextController,
                        decoration: InputDecoration(
                            labelText: 'Write Something',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          height: 45,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          onPressed: () {
                            addData();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add Data',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: const Icon(Icons.add),
      ),
    );
  }
}
