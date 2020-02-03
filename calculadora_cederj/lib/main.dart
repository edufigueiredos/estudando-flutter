import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: new Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Calculadora CEDERJ'),
        centerTitle: true,
      ),
      body: bodyApp(),
    );
  }
}

Widget bodyApp() {
  return Center(
        widthFactor: 200,
        heightFactor: 200,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('CALCULADORA'),
                color: Colors.blue,
                padding: EdgeInsets.all(20),
                onPressed: () {},
              ),
              Divider(),
              RaisedButton(
                onPressed: () {},
                child: Text('Botão Raised'),
                color: Colors.blue,
                padding: EdgeInsets.all(20),
              )
            ],
          ),
        ),
      );
}
