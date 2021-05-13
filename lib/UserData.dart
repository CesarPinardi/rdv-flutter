class Todo {
  String id;
  String username;
  String password;
  String gerencia;
  String equipe;
  String direcao;
  String cdUser;
  String ativo;

  Todo(
      {this.id,
      this.username,
      this.password,
      this.gerencia,
      this.equipe,
      this.direcao,
      this.cdUser,
      this.ativo});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    gerencia = json['gerencia'];
    equipe = json['equipe'];
    direcao = json['direcao'];
    cdUser = json['cd_user'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['gerencia'] = this.gerencia;
    data['equipe'] = this.equipe;
    data['direcao'] = this.direcao;
    data['cd_user'] = this.cdUser;
    data['ativo'] = this.ativo;
    return data;
  }
}
