import 'package:flutter/material.dart';
import 'package:untitled/services/oauth_service.dart';

class RecruitmentDetailPage extends StatefulWidget {
  RecruitmentDetailPage({Key key, @required this.detail}) : super(key: key);

  final Map<String, dynamic> detail;
  final String title = "Recruitment Detail";

  @override
  _RecruitmentDetailPageState createState() =>
      new _RecruitmentDetailPageState();
}

class _RecruitmentDetailPageState extends State<RecruitmentDetailPage> {
  final cardNoCtrl = TextEditingController();
  final creditCtrl = TextEditingController();
  bool isAccept = false;

  updateCardNo(context) async {
    OAuthService()
        .updateCardNo(widget.detail["idcontact"], cardNoCtrl.text)
        .then((result) {
      checkResult(context, result);
    });
  }

  updateCreditGuaranteeNo(context) async {
    OAuthService()
        .updateCreditGuaranteeNo(widget.detail["idcontact"], creditCtrl.text)
        .then((result) {
      checkResult(context, result);
    });
  }

  receiveRecruitment(context) async {
    OAuthService()
        .receiveRecruitment(widget.detail["idcontact"])
        .then((result) {
      bool isSuccess = checkResult(context, result);
      if (isSuccess) {
        setState(() {
          isAccept = true;
        });
      }
    });
  }

  bool checkResult(context, result) {
    bool isSuccess = OAuthService.isServiceSuccess(result);
    String message = isSuccess ? "Saved" : "Failed";
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    Scaffold.of(context).showSnackBar(snackBar);
    return isSuccess;
  }

  @override
  void initState() {
    super.initState();
    cardNoCtrl.text = widget.detail["cardNo"];
    creditCtrl.text = widget.detail["creditGuaranteeNo"];
    isAccept = (widget.detail["accStatus"] == "S");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) => new Column(
              children: <Widget>[
                (isAccept
                    ? Container()
                    : RaisedButton(
                        onPressed: () => receiveRecruitment(context),
                        child: Text("Accept"),
                      )),
                new ListTile(
                  title: TextFormField(
                    controller: cardNoCtrl,
                    decoration: InputDecoration(labelText: 'Card No'),
                    enabled: (isAccept ? true : false),
                  ),
                  trailing: ButtonTheme(
                    minWidth: 40.0,
                    child: RaisedButton(
                      onPressed: () => updateCardNo(context),
                      child: Icon(Icons.save),
                    ),
                  ),
                ),
                new ListTile(
                  title: TextFormField(
                    controller: creditCtrl,
                    decoration:
                        InputDecoration(labelText: 'Credit Guarantee No'),
                    enabled: (isAccept ? true : false),
                  ),
                  trailing: ButtonTheme(
                    minWidth: 40.0,
                    child: RaisedButton(
                      onPressed: () => updateCreditGuaranteeNo(context),
                      child: Icon(Icons.save),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
