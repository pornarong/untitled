import 'package:flutter/material.dart';
import 'package:untitled/services/oauth_service.dart';
import 'package:untitled/recruitment_detail.dart';
import 'dart:async';

class RecruitmentPage extends StatefulWidget {
  RecruitmentPage({Key key}) : super(key: key);

  final String title = "Recruitment";

  @override
  State<StatefulWidget> createState() => _RecruitmentPageState();
}

class _RecruitmentPageState extends State<RecruitmentPage> {

  Future getData() async {
    var result = await OAuthService().getRecruitment();
    return result["responseRecord"]["recruitmentList"];
  }

  void refresh() {
    getData().then((result) {
      setState(() {

      });
    });
  }

  gotoDetailPage(context, detail) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecruitmentDetailPage(detail: detail),
      ),
    ).then((value) {
      // getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget createListView(_, AsyncSnapshot snapshot) {
      print(snapshot.data);
      List values = snapshot.data;
      values.sort((a, b) => b["idcontact"].compareTo(a["idcontact"]));
      return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          String cardNo = values[index]["cardNo"] ?? "";
          String creditGuaranteeNo = values[index]["creditGuaranteeNo"] ?? "";
          return new Column(
            children: <Widget>[
              new ListTile(
                leading: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Icon(
                      Icons.credit_card,
                      color: cardNo.isEmpty ? Colors.grey : Colors.green,
                    ),
                    new Icon(
                      Icons.account_box,
                      color: creditGuaranteeNo.isEmpty
                          ? Colors.grey
                          : Colors.green,
                    ),
                  ],
                ),
                title: new Text(values[index]["name"] ?? ""),
                subtitle: new Text(values[index]["idcontact"] ?? ""),
                trailing: new Icon(Icons.chevron_right),
                onTap: () => gotoDetailPage(context, values[index]),
              ),
              new Divider(
                height: 1.0,
              ),
            ],
          );
        },
      );
    }

    var futureBuild = FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[new Expanded(child: futureBuild)],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: refresh,
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
