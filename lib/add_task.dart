import 'package:flutter/material.dart';
import 'package:to_do_sample/model/todos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

Future<TaskModel?> submitData(String title, bool status) async {
  var url = Uri.parse(baseUrl);
  var bodyData = json.encode({'title': title, 'completed': status});
  var response = await http.post(url, body: bodyData);

  if (response.statusCode == 201) {
    print('Successfully added a task!');
    var display = response.body;
    print(display);

    String todoResponse = response.body;
    taskFromJson(todoResponse);
  } else {
    return null;
  }
  return null;
}

class _AddTaskState extends State<AddTask> {
  TaskModel? task;

  final _formKey = GlobalKey<FormState>();

  var title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO LIST'),
        centerTitle: true,
        titleTextStyle:
            const TextStyle(color: Color.fromRGBO(255, 255, 255, 10)),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  icon: Icon(Icons.check_box_outlined),
                  hintText: 'Buy Groceries',
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  child: const Text(
                    'ADD TASK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      TaskModel? data = await submitData(title.text, false);
                      setState(() {
                        task = data;
                      });
                    } else {
                      return;
                    }
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
