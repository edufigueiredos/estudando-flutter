import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    if (_toDoController.text.isNotEmpty) {
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo['title'] = _toDoController.text;
        newToDo['ok'] = false;
        _toDoController.text = '';
        _toDoList.add(newToDo);

        _saveData();
      });
    }
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          child: Icon(Icons.delete, color: Colors.white),
          alignment: Alignment(-0.9, 0),
        )
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
          title: Text(_toDoList[index]['title']),
          value: _toDoList[index]['ok'],
          secondary: CircleAvatar(
            child: Icon(_toDoList[index]['ok'] ? Icons.check : Icons.error),
          ),
          onChanged: (check) {
            setState(() {
              _toDoList[index]['ok'] = check;
              _saveData();
            });
          },
        ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: InputDecoration(
                          labelText: 'Nova Tarefa',
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text('ADD'),
                    textColor: Colors.white,
                    onPressed: _addToDo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: buildItem,
                padding: EdgeInsets.only(top: 10),
                itemCount: _toDoList.length,
              ),
            )
          ],
        ));
  }
}
