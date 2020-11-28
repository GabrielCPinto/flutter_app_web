import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterappweb/models/clima.model.dart';
import 'package:http/http.dart' as http;

//import 'package:social_share/social_share.dart'; // dependencies: social_share: ^2.0.5

void main() {
  runApp(MaterialApp(
    title: 'Lista',
    debugShowCheckedModeBanner: false,
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _formKey = GlobalKey<FormState>();
  var _itemController = TextEditingController();
  List _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Cidades'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var itens =
              _lista.reduce((value, element) => value + '\n' + element);
              //SocialShare.shareWhatsapp("Lista de Compras:\n" + itens)
              //.then((data) {
              //print(data);
              //     });
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (int i = 0; i < _lista.length; i++)
              ListTile(
                  leading: ExcludeSemantics(
                    child: CircleAvatar(child: Text('${i + 1}')),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _lista[i].toString(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cloud_circle,
                          size: 20.0,
                          color: Colors.blue[900],
                        ),
                        onPressed: () async{
                            Cidade clima=await pegaClima(_lista.elementAt(i),_lista,i);
                            mostraClima(clima,context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                          color: Colors.yellow[900],
                        ),
                        onPressed: () {
                          setState(() {
                            _edit(context,_lista,i);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.red[900],
                        ),
                        onPressed: () {
                          setState(() {
                            _lista.removeAt(i);
                          });
                        },
                      ),
                    ],
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayDialog(context),
      ),
    );
  }

  _displayDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _itemController,
                validator: (s) {
                  if (s.isEmpty)
                    return "Digite o item.";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Item"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('SALVAR'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _lista.add(_itemController.text);
                      _itemController.text = "";
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
  Future<Cidade> pegaClima(texto,lista,i) async {
    Cidade clima;
    var URL="https://api.hgbrasil.com/weather?fields=only_results,city_name,description,date&key=USERKEY&city_name="+texto;
    final resultado= await http.get(URL);
    if(resultado.statusCode==200){
      clima=Cidade.fromJson(json.decode(resultado.body));
      return clima;
    }else{
      print("erro");
    }

  }

  mostraClima(cidade,context){
    return showDialog(context:context,builder:(context){
    return AlertDialog(
      content: Container(
        height: 80,
        child: Column(
          children: [new Text(cidade.date),new Text(cidade.city_name),new Text(cidade.description)],
        )
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  });
  }

  _edit(context,lista,i) async {

    _itemController.text=_lista.elementAt(i);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _itemController,
                validator: (s) {
                  if (s.isEmpty)
                    return "Digite o item.";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Item"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('SALVAR'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _lista.removeAt(i);
                      _lista.add(_itemController.text);
                      _itemController.text = "";
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
