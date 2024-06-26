import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/perfil.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexão',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Conexão'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msg = "Tente se Conectar.";
  TextEditingController controlLogin = TextEditingController();
  TextEditingController controlSenha = TextEditingController();

  Future<void> _logar() async {
    final response = await http
        .post(Uri.parse("http://localhost/flutterconn/login.php"), body: {
      "username": controlLogin.text,
      "senha": controlSenha.text
    }, headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });

    var data = json.decode(response.body);

    if (data.length != 0) {
      var id = int.parse(data[0]["idlogin"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil(idlogin: id)),
      );
    } else {
      setState(() {
        msg = "Login Invalido!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Login"),
              ),
              TextFormField(
                controller: controlLogin,
              ),
              Text("Senha"),
              TextFormField(
                obscureText: true,
                controller: controlSenha,
              ),
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                onPressed: () {
                  _logar();
                },
                child: Text("Login"),
              ),
              const SizedBox(
                height: 25,
              ),
              Text("LOG: " + msg)
            ],
          ),
        ));
  }
}
