import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
import 'package:flutter_app/login_api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String login, password = '';
  TextEditingController loginController = new TextEditingController();
  TextEditingController senhaController = new TextEditingController();
  bool _isHidden = true;

  Widget _body() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/logo.jpg'),
              ),
              Container(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: loginController,
                        onChanged: (text) {
                          login = text;
                          print(text);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Usuário',
                          suffixIcon: IconButton(
                            onPressed: () => loginController.clear(),
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      Container(height: 20),
                      TextField(
                        controller: senhaController,
                        onChanged: (text) {
                          password = text;
                          print(text);
                        },
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            onPressed: () => senhaController.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          suffix: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      Container(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue, onPrimary: Colors.white),
                        onPressed: () {
                          enviarDados();
                        },
                        child: Container(
                          width: 100,
                          child: Text(
                            'Entrar',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showToast(BuildContext context) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    await Future.delayed(Duration(seconds: 1));
    ScaffoldFeatureController controller = scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Usuário ou senha incorretos')),
    );
    final result = await controller.closed;
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.lightBlue,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            //aqui pode ir uma img de background com Image.asset(),
            /*SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.asset('', fit: BoxFit.cover,),
          )*/
            _body(),
          ],
        ));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> enviarDados() async {
    String login = loginController.text;
    String pass = senhaController.text;

    print('login:' + loginController.text);
    print('senha:' + senhaController.text);

    var response = await LoginApi.login(login, pass);

    if (response) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new HomePage(value: login),
      );
      Navigator.of(context).push(route);
    }
    if (!response) {
      _showToast(context);
    }
  }
}
