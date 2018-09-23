import 'dart:core';

class User {
  String agentCode = "";
  String cardNo = "";
  String firstNameTh = "";
  String lastNameTh = "";
  String firstNameEn = "";
  String lastNameEn = "";
  String branchName = "";
  String profileImg = "";
  String upperCode = "";
  String strid = "";
  String depositNo = "";

  User();

  User.fromJson(Map<String, dynamic> json)
      : agentCode = json['agentCode'],
        cardNo = json['cardNo'],
        firstNameTh = json['firstNameTh'],
        lastNameTh = json['lastNameTh'],
        firstNameEn = json['firstNameEn'],
        lastNameEn = json['lastNameEn'],
        branchName = json['branchName'],
        profileImg = json['profileImg'],
        upperCode = json['upperCode'],
        strid = json['strid'],
        depositNo = json['depositNo'];
}
