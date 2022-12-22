import 'package:flutter/material.dart';
import 'package:to_do_sample/db/todo_database.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final completed = TextEditingController();

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
        key: formKey,
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
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: completed,
                decoration: const InputDecoration(
                  icon: Icon(Icons.question_mark),
                  hintText: 'Yes/No',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Yes if the task is finished, otherwise enter No';
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
                    if (formKey.currentState!.validate()) {
                      var data =
                          await SQLHelper.addTask(title.text, completed.text);

                      Navigator.pop(context, data);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
