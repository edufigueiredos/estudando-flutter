import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=7759f03a';

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber))))));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double peso;
  double bitcoin;

  void _resetFields() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
    pesoController.text = '';
    bitcoinController.text = '';
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _resetFields();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    pesoController.text = (real / peso).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _resetFields();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2);
    bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _resetFields();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
  }

  void _pesoChanged(String text) {
    if (text.isEmpty) {
      _resetFields();
      return;
    }

    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    bitcoinController.text = (peso * this.peso / bitcoin).toStringAsFixed(2);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _resetFields();
      return;
    }

    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
    pesoController.text = (bitcoin * this.bitcoin / peso).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text('Conversor de Moedas', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                'Carregando Dados...',
                style: TextStyle(color: Colors.amber, fontSize: 25),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Erro ao carregar dados',
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                peso = snapshot.data['results']['currencies']['ARS']['buy'];
                bitcoin = snapshot.data['results']['currencies']['BTC']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      buildTextField(
                          'Reais', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextField(
                          'Dólares', 'US\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          'Euros', '€', euroController, _euroChanged),
                      Divider(),
                      buildTextField(
                          'Peso Argentino', '\$', pesoController, _pesoChanged),
                      Divider(),
                      buildTextField(
                          'BitCoin', 'BTC', bitcoinController, _bitcoinChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function convert) {
  return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        prefixText: '$prefix ',
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
      ),
      style: TextStyle(color: Colors.amber),
      onChanged: convert,
      keyboardType: TextInputType.numberWithOptions(decimal: true));
}
