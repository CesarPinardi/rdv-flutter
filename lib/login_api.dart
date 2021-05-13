import 'package:http/http.dart' as http;

class LoginApi {
  static Future<bool> login(String user, String password) async {
    var url = Uri.parse('http://189.1.174.107:8080/app/user_control.php');

    Map params = {
      'username': user,
      'password': password,
    };

    print('json enviado' + params.toString());

    var response = await http.post(url, body: params);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    String auxBody = response.body.toString();

    String auxaux = auxBody[4];

    print("aux char at 2: " + auxaux);

    if (auxaux == 's') {
      return true;
    } else {
      return false;
    }

    /** e se der um decode no json verificando o success**/
  }
}
