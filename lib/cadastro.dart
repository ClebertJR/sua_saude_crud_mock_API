import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sua_saude_app/home.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);
  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Função Post
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController especialidadeController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  Future<void> enviarDados(context) async {
    final url =
        Uri.parse('https://6449a192b88a78a8f00c470f.mockapi.io/Agendamento');
    final response = await http.post(url, body: {
      'nome': nomeController.text,
      'telefone': telefoneController.text,
      'especialidade': especialidadeController.text,
      'data': dataController.text,
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados enviados com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar dados')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamento de Consultas"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  hintText: 'Digite seu nome completo',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Você precisa digitar seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  hintText: 'Digite seu seu telefone',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Você precisa digitar seu telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: especialidadeController,
                decoration: const InputDecoration(
                  hintText:
                      'Para qual especialidade médica você precisa agendar?',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Você precisa digitar uma especialidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(
                  hintText: 'Para qual data?',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Você precisa digitar uma data';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      enviarDados(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.white))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
