class Agendamento {
  //Atributos da classe
  String? id;
  String? nome;
  String? telefone;
  String? especialidade;
  String? data;

  //Construtor da classe
  Agendamento(
      {this.id, this.nome, this.telefone, this.especialidade, this.data});

  //Método que converte Json em Map
  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      especialidade: json['especialidade'],
      data: json['data'],
    );
  }
}
