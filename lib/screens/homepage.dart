import 'package:flutter/material.dart';
import 'package:to_do_sample/edit_task.dart';
import 'package:to_do_sample/add_task.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const String baseURL = 'https://jsonplaceholder.typicode.com/todos';

class _HomePageState extends State<HomePage> {
  List getResponse = <dynamic>[];

  getTodo() async {
    var url = Uri.parse(baseURL);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        getResponse = jsonDecode(response.body) as List<dynamic>;
      });
    } else {
      return null;
    }
  }

  deleteTodo(var object) async {
    var url = Uri.parse('$baseURL/${object["id"]}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print(
          'Successfully deleted task: ${object["title"]} ID: ${object["id"]}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(
            'Successfully deleted task: ${object["title"]} ID: ${object["id"]}'),
        action: SnackBarAction(
            label: 'DISMISS',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ));
    } else {
      return null;
    }
  }

  displayEditedTask(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepPurple,
        content: Text(
            'Successfully edited task: ${object["title"]} ID: ${object["id"]}')));
  }

  displayCreatedTask(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepPurple,
        content: Text(
            'Successfully created task: ${object["title"]} ID: ${object["id"]}')));
  }

  @override
  void initState() {
    getTodo();
    super.initState();
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
        itemCount: getResponse.length,
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
              title: Text('${getResponse[index]['title']}'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.deepPurple,
              secondary: IconButton(
                onPressed: () async {
                  var check = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditTask(todo: getResponse[index])));
                  if (check != null) {
                    displayEditedTask(getResponse[index]);
                  } else {
                    print('No changes were made');
                  }
                },
                icon: const Icon(Icons.edit),
                color: Colors.black,
              ),

              value: getResponse[index]['completed'],
              onChanged: (bool? value) {
                setState(() {
                  getResponse[index]['completed'] = value!;
                });
              },
            ),
            onDismissed: (direction) =>
              setState(() {
                deleteTodo(getResponse[index]);
                getResponse.removeAt(index);
              })
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const AddTask(),
          );
        },
        tooltip: 'Add a new item!',
        child: const Icon(Icons.bookmark_add_outlined),
      ),
    );
  }
}
