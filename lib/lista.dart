import 'package:flutter/material.dart';
import 'package:sua_saude_app/home.dart';
import 'package:sua_saude_app/models/agendamento.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Agendamento> agendamentos = [];

  //Método Get
  Future<List<Agendamento>> listarAgendamentos() async {
    final response = await http.get(
        Uri.parse('https://6449a192b88a78a8f00c470f.mockapi.io/Agendamento'));
    if (response.statusCode == 200) {
      final List<dynamic> agendamentoJsonList = json.decode(response.body);
      return agendamentoJsonList
          .map((json) => Agendamento.fromJson(json))
          .toList();
    } else {
      throw Exception('Falha ao carregar dados!');
    }
  }

  //Método Delete
  Future<bool> deleteRegistro(String? id) async {
    final response = await http.delete(
      Uri.parse('https://6449a192b88a78a8f00c470f.mockapi.io/Agendamento/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        agendamentos.removeWhere((agendamento) => agendamento.id == id);
      });
      return true;
    } else {
      return false;
    }
  }

  //Função para editar informações de um registro, abrindo uma Alert Dialog Form
  late String id;
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController especialidadeController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  editarRegistro(Agendamento agendamento) {
    id = agendamento.id!;
    nomeController.text = agendamento.nome!;
    telefoneController.text = agendamento.telefone!;
    especialidadeController.text = agendamento.especialidade!;
    dataController.text = agendamento.data!;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Editar Informações"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                          labelText: "Nome Completo",
                          hintText: "Digite aqui..."),
                    ),
                    TextField(
                      controller: telefoneController,
                      decoration: const InputDecoration(
                          labelText: "Telefone para contato",
                          hintText: "Digite aqui..."),
                    ),
                    TextField(
                      controller: especialidadeController,
                      decoration: const InputDecoration(
                          labelText: "Especializadade médica",
                          hintText: "Digite aqui..."),
                    ),
                    TextField(
                      controller: dataController,
                      decoration: const InputDecoration(
                          labelText: "Data da consulta",
                          hintText: "Digite aqui..."),
                    )
                  ],
                );
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.white))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
              ElevatedButton(
                  onPressed: () {
                    atualizarDados(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.white))),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple),
                  ),
                  child: const Text(
                    "Salvar Edição",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))
            ],
          );
        });
  }

  //Método Put
  atualizarDados(context) async {
    final url = 'https://6449a192b88a78a8f00c470f.mockapi.io/Agendamento/$id';

    final response = await http.put(Uri.parse(url), body: {
      'nome': nomeController.text,
      'telefone': telefoneController.text,
      'especialidade': especialidadeController.text,
      'data': dataController.text,
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro atualizado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Consultas Agendadas"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: FutureBuilder<List<Agendamento>>(
          future: listarAgendamentos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final agendamentos = snapshot.data!;
              return ListView.builder(
                itemCount: agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = agendamentos[index];
                  return Card(
                      color: Colors.deepPurple.withOpacity(0.5),
                      child: ListTile(
                        title: Text(
                          "Paciente: ${agendamento.nome} | Fone: ${agendamento.telefone} | Especialidade ${agendamento.especialidade}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "Data da consulta: ${agendamento.data}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                editarRegistro(agendamento);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    Text('Editar',
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool sucesso =
                                    await deleteRegistro(agendamento.id);
                                if (sucesso) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Agendamento removido com sucesso!')),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Falha ao remover agendamento!')),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar dados!');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
