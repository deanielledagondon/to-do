import 'package:flutter/material.dart';
import 'package:to_do_sample/db/todo_database.dart';
import 'package:to_do_sample/edit_task.dart';
import 'package:to_do_sample/add_task.dart';
import 'dart:core';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _todoList = [];

  void _refreshTask() async {
    final data = await SQLHelper.getAllTasks();
    setState(() {
      _todoList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do App'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(255, 255, 255, 10),
          fontSize: 20,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
            child: CheckboxListTile(
              title: Text(_todoList[index]['title']),
              subtitle: Text(_todoList[index]['isDone']),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.deepPurple,
              value: _todoList[index]['isDone'],
              secondary: IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTask(
                                userID: _todoList[index]['id'],
                                taskTitle: _todoList[index]['title'],
                                isDone: _todoList[index]['isDone'],
                              )));
                  _refreshTask();
                },
                icon: const Icon(Icons.edit),
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  _todoList[index]['isDone'] = value!;
                });
              },
            ),
            onDismissed: (direction) async {
              await SQLHelper.deleteTask(_todoList[index]['id']);
              _refreshTask();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const AddTask(),
          );
          _refreshTask();
        },
        tooltip: 'Add a new item!',
        child: const Icon(Icons.bookmark_add_outlined),
      ),
    );
  }
}
