import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Dados {
  // ignore: non_constant_identifier_names
  String cd_user;
  String direcao;
  String gerencia;
  String equipe;
  // ignore: non_constant_identifier_names
  int id_desp;
  // ignore: non_constant_identifier_names
  Double valor_desp;
  Double km;
  String obs;
  String dataM;
  Characters statusM;
  String obsRep;

  // ignore: non_constant_identifier_names
  Dados(
      {this.cd_user, // ignore: non_constant_identifier_names
      this.direcao,
      this.gerencia,
      this.equipe,
      this.id_desp,
      this.valor_desp,
      this.km,
      this.obs,
      this.dataM,
      this.statusM,
      this.obsRep});

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      cd_user: json['cd_user'] as String,
      direcao: json['direcao'] as String,
      gerencia: json['gerencia'] as String,
      equipe: json['equipe'] as String,
      id_desp: json['id_desp'] as int,
      valor_desp: json['valor_desp'] as Double,
      km: json['km'] as Double,
      obs: json['obs'] as String,
      statusM: json['statusM'] as Characters,
      obsRep: json['obsRep'] as String,
    );
  }
}
