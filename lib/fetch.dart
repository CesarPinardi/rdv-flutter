import 'dart:convert';

import 'UserData.dart';
import 'package:http/http.dart' as http;

Future<Todo> fetch(String username) async {
  var url = 'http://189.1.174.107:8080/app/dadosUser.php/?cd_user=' + username;
  var response = await http.get(Uri.parse(url));

  var json = jsonDecode(response.body);

  var todo = Todo.fromJson(json[0]);

  var equipe = todo.equipe;
  var direcao = todo.direcao;
  var gerencia = todo.gerencia;
  var usr = todo.username;
  var pss = todo.password;
  var a = todo.ativo;

  print("Username:" + usr);
  print("Password:" + pss);

  if (a == 'A') {
    print("Ativo");
  } else {
    print("Inativo");
  }

  print("equipe:" + equipe);
  print("direcao:" + direcao);
  print("gerencia:" + gerencia);

  return todo;
}
