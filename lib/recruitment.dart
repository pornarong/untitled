import 'package:flutter/material.dart';
import 'package:untitled/services/oauth_service.dart';
import 'package:untitled/recruitment_detail.dart';

class RecruitmentPage extends StatefulWidget {
  RecruitmentPage({Key key}) : super(key: key);

  final String title = "Recruitment";

  @override
  _RecruitmentPageState createState() => new _RecruitmentPageState();
}

class _RecruitmentPageState extends State<RecruitmentPage> {
  List<Widget> listArray = new List();

  getData() async {
    var result = await OAuthService().getRecruitment();
    List list = result["responseRecord"]["recruitmentList"];
    listArray = new List();

    for (var i = 0; i < list.length; i++) {
      String cardNo = list[i]["cardNo"] ?? "";
      String creditGuaranteeNo = list[i]["creditGuaranteeNo"] ?? "";
      listArray.add(new ListTile(
        leading: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(Icons.credit_card,
              color: cardNo.isEmpty ? Colors.grey : Colors.green,),
            new Icon(Icons.account_box,
              color: creditGuaranteeNo.isEmpty ? Colors.grey : Colors.green,),
          ],
        ),
        title: new Text(list[i]["name"]),
        subtitle: new Text(list[i]["idcontact"]),
        trailing: new Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecruitmentDetailPage(detail: list[i]),
            ),
          ).then((value) {
            getData();
          });
        },
      ));
    }

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                child:
                new ListView(children: listArray != null ? listArray : []))
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getData,
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
