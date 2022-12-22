import 'package:flutter/material.dart';
import 'package:to_do_sample/db/todo_database.dart';

// http.patch

class EditTask extends StatefulWidget {
  final int userID;
  final String taskTitle;
  final bool isDone;

  const EditTask(
      {Key? key,
      required this.userID,
      required this.taskTitle,
      required this.isDone})
      : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var id = 0;

  final titleController = TextEditingController();
  final completed = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    id = widget.userID;
    titleController.text = widget.taskTitle;
    completed.text = widget.isDone.toString();
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
                padding: const EdgeInsets.all(18),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var data = SQLHelper.editTask(
                          id, titleController.text, completed.text);
                      Navigator.pop(context, data);
                    } else {
                      return;
                    }
                  },
                  child: const Text(
                    'SUBMIT NEW TASK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
