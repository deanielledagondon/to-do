import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTask extends StatefulWidget {
  final dynamic todo;

  const EditTask({required this.todo, Key? key}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class _EditTaskState extends State<EditTask> {
  var id = '';
  var check;

  final titleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo["title"];
    id = widget.todo["id"].toString();
    check = widget.todo["title"];
  }

  editUser() async {
    var newTitle = titleController.text;
    var url = Uri.parse('$baseUrl/$id');
    var bodyData = json.encode({
      'title': newTitle,
    });
    var response = await http.patch(url, body: bodyData);
    if (response.statusCode == 200) {
      print('\nSuccessfully edited Task id: $id!');
      var display = response.body;
      print(display);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 10),
            fontSize: 20,
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.check_box_outlined),
                  hintText: 'Buy Dog Food',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new task';
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(18),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (check != titleController.text) {
                        await editUser();
                        Navigator.pop(context, check);
                      } else {
                        return;
                      }
                    } else {
                      return;
                    }
                  },
                  child: const Text('SUBMIT NEW TASK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              ),
            ],
          ),
        ));
  }
}
