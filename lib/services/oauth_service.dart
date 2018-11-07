import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

class OAuthService {

  String username = "";
  String password = "";
  String server = "";

  _generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  _getClient() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    password = prefs.getString("password");
    server = prefs.getString("server");

    final authorizationEndpoint = Uri.parse(
        "$server/MDAWebService/oauth/token?is_admin=Y");

    final identifier = "jlo-trusted-client";
    final secret = "locus123";

    var client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint, username, _generateMd5(password),
        identifier: identifier, secret: secret);

    return client;
  }

  _getDateTime() {
    return formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]);
  }

  _getRequestMessage(requestRecord) {
    return {
      "headerData": {
        "messageId": "FL",
        "sentDateTime": _getDateTime(),
        "recordPerPage": 50
      },
      "requestRecord": requestRecord
    };
  }

  Future<dynamic> getProfile() async {
    var client = await _getClient();

    var requestRecord = {"agentCode": username};
    var body = _getRequestMessage(requestRecord);

    var result = await client.post(
        "$server/MDAWebService/api/user/getProfile",
        headers: {"content-type": "application/json"},
        body: json.encode(body));

    print(result.body);

    return json.decode(result.body);
  }

  Future<dynamic> getRecruitment() async {
    var client = await _getClient();

    var requestRecord = {"agentCode": username};
    var body = _getRequestMessage(requestRecord);

    var result = await client.post(
        "$server/MDAWebService/api/recruitment/getRecruitmentList",
        headers: {"content-type": "application/json"},
        body: json.encode(body));

    print(result.body);
    return json.decode(result.body);
  }

  Future<dynamic> receiveRecruitment(String refId) async {
    var client = await _getClient();

    var requestRecord = {
      "agentCode": username
      , "refIdList": [refId]
    };
    var body = _getRequestMessage(requestRecord);

    var result = await client.post(
        "$server/MDAWebService/api/recruitment/receiveRecruitment",
        headers: {"content-type": "application/json"},
        body: json.encode(body));

    return json.decode(result.body);
  }

  Future<dynamic> updateCardNo(String refId, String cardNo) async {
    var client = await _getClient();

    var requestRecord = {
      "agentCode": username
      , "refId": refId
      , "cardNo": cardNo
    };
    var body = _getRequestMessage(requestRecord);

    var result = await client.post(
        "$server/MDAWebService/api/recruitment/updateRecruitmentCardNo",
        headers: {"content-type": "application/json"},
        body: json.encode(body));

    return json.decode(result.body);
  }

  Future<dynamic> updateCreditGuaranteeNo(String refId, String creditGuaranteeNo) async {
    var client = await _getClient();

    var requestRecord = {
      "agentCode": username
      , "refId": refId
      , "creditGuaranteeNo": creditGuaranteeNo
    };
    var body = _getRequestMessage(requestRecord);

    var result = await client.post(
        "$server/MDAWebService/api/recruitment/updateCreditGuaranteeNo",
        headers: {"content-type": "application/json"},
        body: json.encode(body));

    return json.decode(result.body);
  }

  static bool isServiceSuccess(dynamic result) {
    return result != null && result["responseStatus"] != null && result["responseStatus"]["statusCode"] == "S";
  }

}