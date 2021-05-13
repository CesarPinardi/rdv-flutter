import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_app/config';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

// ignore: must_be_immutable
class EnvioFoto extends StatefulWidget {
  final String value;
  String status = '';
  final String despesa;
  // ignore: non_constant_identifier_names
  final String valor_desp;
  final String obs;
  final String data;
  // ignore: non_constant_identifier_names
  final String id_desp;
  final String km;
  EnvioFoto(
      // ignore: non_constant_identifier_names
      {Key key,
      this.value,
      this.despesa,
      this.valor_desp,
      this.obs,
      this.data,
      this.id_desp,
      this.km})
      : super(key: key);

  @override
  State<EnvioFoto> createState() {
    //Intl.defaultLocale = 'pt_BR';

    return EnvioFotoStates();
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class EnvioFotoStates extends State<EnvioFoto> {
  Timer _timer;

  String login = '';
  String desp = '';
  String vlrDesp = '';
  String observ = '';
  String dataM = '';
  String idDesp = '';
  String result = '';
  String qtdKm = '';

  var loginController = new TextEditingController(text: '');
  var despesaController = new TextEditingController(text: '');
  var idDespController = new TextEditingController(text: '');
  var valorDespesaController = new TextEditingController(text: '');
  var obsController = new TextEditingController(text: '');
  var dataController = new TextEditingController(text: '');
  var kmController = new TextEditingController(text: '');

  List<Asset> images = [];

  Dio dio = Dio();

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          quality: 80,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    configLoading();
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          autoCloseOnSelectionLimit: true,
          actionBarColor: "#ff039be5",
          actionBarTitle: "RDV",
          allViewTitle: "Todas as fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  _saveImage() async {
    if (images != null) {
      // ignore: unused_local_variable
      int count = 0;
      for (var i = 0; i < images.length; i++) {
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: images[i].name,
          contentType: MediaType('image', 'jpg'),
        );

        String novaData = dataController.text;
        //cortando a string pra enviar só a data
        result = novaData.substring(0, 10);

        print("despesaController.text" + despesaController.text);
        print("IDDespController.text" + idDespController.text);

        FormData formData = FormData.fromMap({
          "image": multipartFile,
          "cd_user": loginController.text,
          "direcao": "DIRECAO",
          "gerencia": "DIRECAO",
          "equipe": "DIRECAO",
          "id_desp": idDespController.text,
          "valor_desp": valorDespesaController.text,
          "km": kmController.text,
          "obs": obsController.text,
          "dataM": result,
          "statusM": 'A',
          "obsRep": '',
        });

        EasyLoading.show(status: "Carregando...");
        var response = await dio.post(UPLOAD_URL, data: formData);
        if (response.statusCode == 200) {
          count++;
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Confirmado!");
          print("response.data:" + response.data);
          await Future.delayed(Duration(seconds: 2));

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
          }
        } else {
          EasyLoading.showError("Erro ao enviar! " + response.statusMessage);
          await Future.delayed(Duration(seconds: 2));
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in   initState');
  }

  @override
  Widget build(BuildContext context) {
    loginController.text = '${widget.value}';
    despesaController.text = '${widget.despesa}';
    valorDespesaController.text = '${widget.valor_desp}';
    obsController.text = '${widget.obs}';
    dataController.text = '${widget.data}';
    idDespController.text = '${widget.id_desp}';
    kmController.text = '${widget.km}';

    print('loginController.text: ' + loginController.text);
    print('despesaController.text: ' + despesaController.text);
    print('valorDespesaController.text: ' + valorDespesaController.text);
    print('obsController.text: ' + obsController.text);
    print('dataController.text: ' + dataController.text);
    print('IDDesp.text: ' + idDespController.text);
    print('KM.text: ' + kmController.text);
    String novaData = dataController.text;
    //cortando a string pra enviar só a data
    result = novaData.substring(0, 10);

    print('nova Data: ' + result);

    return new MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          "Fotos",
          style: TextStyle(color: Colors.white),
        )),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(height: 20),
                  Container(
                    width: 200.0,
                    height: 40.0,
                    child: TextField(
                      controller: despesaController,
                      onChanged: (text) {
                        desp = text;
                        print(text);
                      },
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Despesa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(height: 20),
                  ElevatedButton(
                    onPressed: loadAssets,
                    child: Container(
                      width: 140,
                      child: Text(
                        'Escolher imagem',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(height: 20),
                  Expanded(
                    child: buildGridView(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveImage();
                    },
                    child: Container(
                      width: 140,
                      child: Text(
                        'Confirmar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
