import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var url = Uri.https(
    'api.hgbrasil.com', '/finance', {'?': 'format=json&key=7ceb919c'});
void main() async {
  var response = await http.get(url);

  //print(json.decode(response.body)["results"]["currencies"]["USD"]);
  print(await buscaDados());

  runApp(MaterialApp(home: Home()));
}

Future<Map> buscaDados() async {
  var response = await http.get(url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  final yenControl = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double yen = 0;
  double real = 0;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarControl.text = (real / dolar).toStringAsFixed(2);
    euroControl.text = (real / euro).toStringAsFixed(2);
    yenControl.text = (real / yen).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realControl.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControl.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    yenControl.text = (dolar * this.dolar / yen).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realControl.text = (euro * this.euro).toStringAsFixed(2);
    dolarControl.text = (euro * this.euro / dolar).toStringAsFixed(2);
    yenControl.text = (euro * this.euro / yen).toStringAsFixed(2);
  }

  void _yenChanged(String text) {
    double yen = double.parse(text);
    realControl.text = (yen * this.yen).toStringAsFixed(2);
    dolarControl.text = (yen * this.yen / dolar).toStringAsFixed(2);
    euroControl.text = (yen * this.yen / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        title: Text("\$ Conversor de moeda \$"),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: buscaDados(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando Dados...",
                  style:
                      TextStyle(color: Colors.green.shade900, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar os Dados...",
                    style:
                        TextStyle(color: Colors.green.shade900, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  yen = snapshot.data!["results"]["currencies"]["JPY"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.payments_outlined,
                            size: 80.0, color: Colors.green.shade900),
                        contruiMeusCamposDeTexto(
                            "Reais", "R\$  ", realControl, _realChanged),
                        Divider(),
                        contruiMeusCamposDeTexto(
                            "Dólares", "US\$  ", dolarControl, _dolarChanged),
                        Divider(),
                        contruiMeusCamposDeTexto(
                            "Euros", "EUR\Є  ", euroControl, _euroChanged),
                        Divider(),
                        contruiMeusCamposDeTexto(
                            "Yens", "JP\¥  ", yenControl, _yenChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget contruiMeusCamposDeTexto(String label, String prefix,
    TextEditingController value, Function changed) {
  return TextField(
    controller: value,
    decoration: InputDecoration(
      suffixIcon: IconButton(
        onPressed: () {
          value.clear();
        },
        icon: Icon(
          Icons.clear_rounded,
          color: Colors.green.shade900,
        ),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.green.shade900),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade900, width: 0.0)),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.green.shade900, fontSize: 20.0),
    ),
    style: TextStyle(color: Colors.green.shade900, fontSize: 20.0),
    onChanged: changed as void Function(String)?,
    keyboardType: TextInputType.number,
  );
}









/*const request = "https://api.hgbrasil.com/finance?format=json&key=7ceb919c";

void main() async {

  http.Response response = await http.get(request);
  
  print(json.decode(response.body));
  
  runApp(MaterialApp(home: Container()));
}*/

