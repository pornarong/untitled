import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:untitled/models/app_state.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  final String title = "Setting";

  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final servCtrl = TextEditingController();

  savePref(AppState model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", userCtrl.text);
    prefs.setString("password", passCtrl.text);
    prefs.setString("server", servCtrl.text);

    model.saveSetting(userCtrl.text, passCtrl.text, servCtrl.text);

    final snackBar = SnackBar(
      content: Text('Saved'),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      userCtrl.text = prefs.getString("username");
      passCtrl.text = prefs.getString("password");
      servCtrl.text = prefs.getString("server");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new ListTile(
              title: TextFormField(
            controller: servCtrl,
            decoration: InputDecoration(labelText: 'Server'),
          )),
          new ListTile(
              title: TextFormField(
            controller: userCtrl,
            decoration: InputDecoration(labelText: 'Username'),
          )),
          new ListTile(
              title: TextFormField(
            controller: passCtrl,
            decoration: InputDecoration(labelText: 'Password'),
          )),
        ],
      ),
      floatingActionButton: ScopedModelDescendant<AppState>(
          builder: (context, child, model) => FloatingActionButton(
                onPressed: () => savePref(model),
                child: new Icon(Icons.save),
              )),
    );
  }
}
