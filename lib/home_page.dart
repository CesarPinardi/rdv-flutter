import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/envio_foto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toast/toast.dart';

import 'CurrencyInputFormatter.dart';

class HomePage extends StatefulWidget {
  final String value;

  HomePage({Key key, this.value}) : super(key: key);

  @override
  State<HomePage> createState() {
    //Intl.defaultLocale = 'pt_BR';
    return HomePageStates();
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class HomePageStates extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  String login = '';
  TextEditingController loginController = new TextEditingController(text: '');
  TextEditingController despesaController = new TextEditingController();
  TextEditingController valorDespesaController = new TextEditingController();
  TextEditingController obsController = new TextEditingController();
  TextEditingController dataController = new TextEditingController();
  TextEditingController valorKmController = new TextEditingController();

  var tcVisibility = false;
  double valor;

  int auxDespesa = 1;

  String km;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021), // Required
      lastDate: DateTime(2025), // Required
    );

    loginController.text = '${widget.value}';

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String _currentItemSelected = 'Alimentação';
  var despesas = [
    'Alimentação',
    'Combustível',
    'Estacionamento',
    'Hospedagem',
    'Outros',
    'Pedágio',
  ];

  @override
  Widget build(BuildContext context) {
    loginController.text = '${widget.value}'.toString();
    valorKmController.text = '0';
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Despesa',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(height: 10),
                      Container(
                          width: 200.0,
                          height: 40.0,
                          child: TextField(
                            controller: loginController,
                            onChanged: (text) {
                              login = text;
                              print(text);
                            },
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )),
                      Container(height: 20),
                      DropdownButton<String>(
                        items: despesas.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._currentItemSelected = newValueSelected;
                            despesaController.text = _currentItemSelected;
                            print(despesaController.text);
                          });

                          print("CurrentItem despesa" + _currentItemSelected);
                          switch (_currentItemSelected) {
                            case 'Alimentação':
                              auxDespesa = 1;
                              tcVisibility = false;
                              /**
                               * setar valor do campo com max 20.00
                               * campo com mascara de dinheiro
                               **/
                              break;
                            case 'Combustível':
                              auxDespesa = 2;
                              tcVisibility = true;
                              break;
                            case 'Estacionameto':
                              auxDespesa = 3;
                              tcVisibility = false;
                              break;
                            case 'Hospedagem':
                              auxDespesa = 4;
                              tcVisibility = false;
                              break;
                            case 'Outros':
                              auxDespesa = 5;
                              tcVisibility = false;
                              break;
                            case 'Pedágio':
                              auxDespesa = 6;
                              tcVisibility = false;
                              break;
                          }
                        },
                        value: _currentItemSelected,
                      ),
                      Container(height: 25),
                      Visibility(
                        visible: tcVisibility,
                        child: Container(
                            width: 200,
                            height: 40,
                            child: TextField(
                              controller: valorKmController,
                              style: TextStyle(fontSize: 15),
                              onChanged: (text) {
                                km = text;
                                print(text);
                              },
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                labelText: 'Quantidade de km',
                                border: OutlineInputBorder(),
                              ),
                            )),
                      ),
                      Container(height: 25),
                      Container(
                          width: 200.0,
                          height: 40.0,
                          child: TextField(
                            controller: valorDespesaController,
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              WhitelistingTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              //fazer o formater para dinheiro
                              CurrencyInputFormatter()
                            ],
                            style: TextStyle(fontSize: 15),
                            onChanged: (text) {},
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: 'Valor da despesa',
                              border: OutlineInputBorder(),
                            ),
                          )),
                      Container(height: 25),
                      Container(
                          width: 200.0,
                          height: 40.0,
                          child: TextField(
                            controller: obsController,
                            style: TextStyle(fontSize: 15),
                            onChanged: (text) {},
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Observação',
                              border: OutlineInputBorder(),
                            ),
                          )),
                      Container(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () =>
                                _selectDate(context), // Refer step 3
                            child: Text(
                              'Selecionar data',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(height: 25),
                          Text(
                            DateFormat("dd/MM/yyyy").format(selectedDate),
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                      Container(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue, onPrimary: Colors.white),
                        onPressed: () {
                          if (verificaValorAlimentacao()) {
                            verificaCampos();
                          }
                        },
                        child: Container(
                          width: 100,
                          child: Text(
                            'Enviar',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  bool verificaValorAlimentacao() {
    if (auxDespesa != 1) {
      return true;
    } else {
      String aux = transformaString();
      valor = double.parse(aux);
      if (valor > 20.00) {
        showToast(
            'Erro ao enviar os dados! Valor de alimentação maior que 20 reais!',
            duration: 4,
            gravity: Toast.BOTTOM);
        return false;
      } else {
        return true;
      }
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<void> verificaCampos() async {
    print("Aux despesa" + auxDespesa.toString());
    String antigaData = selectedDate.toString();
    //cortando a string pra enviar só a data
    String novaData = antigaData.substring(0, 10);

    if (loginController.text.isEmpty ||
        valorDespesaController.text.isEmpty ||
        selectedDate.toString().isEmpty) {
      print("campos não preenchidos");
      showToast('Erro ao enviar os dados! Preencha todos os campos!',
          duration: 4, gravity: Toast.BOTTOM);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new EnvioFoto(
            value: loginController.text,
            despesa: _currentItemSelected,
            valor_desp: valor.toString(),
            obs: obsController.text,
            data: novaData,
            id_desp: auxDespesa.toString(),
            km: valorKmController.text),
      );
      print('login->' + loginController.text);
      print('despesa->' + _currentItemSelected);
      print('auxdespesa->' + auxDespesa.toString());
      print('valordesp->' + valor.toString());
      print('valorkm->' + valorKmController.text);
      print('obs->' + obsController.text);
      print('data.text->' + novaData);
      Navigator.of(context).push(route);
    } //else
  }

  String transformaString() {
    String oldString = valorDespesaController.text.toString();
    String newString = oldString.replaceAll(',', '.');
    print('antigo valor: ' + oldString);
    print('novo valor: ' + newString);

    int startIndex = 2;
    int endIndex = newString.length;

    //find substring
    String result = newString.substring(startIndex, endIndex);

    print('String cortada:' + result);
    return result;
  } //funcao
}
