import 'package:flutter/material.dart';
import 'package:untitled/recruitment.dart';
import 'package:untitled/setting.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:untitled/models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Setting", Icons.settings),
    DrawerItem("Recruitment", Icons.people),
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return SettingPage();
      case 1:
        return RecruitmentPage();
      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String username = prefs.getString("username") ?? "";
      String password = prefs.getString("password") ?? "";
      String server = prefs.getString("server") ?? "";
      if (username.isNotEmpty && password.isNotEmpty && server.isNotEmpty) {
        _selectedDrawerIndex = 1;
        AppState state = ScopedModel.of<AppState>(context);
        state.saveSetting(username, password, server);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
      if (i % 2 == 0) {
        drawerOptions.add(Divider(
          height: 1.0,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            _buildDrawerHeader(),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

var _buildDrawerHeader = () => ScopedModelDescendant<AppState>(
      builder: (context, child, model) => UserAccountsDrawerHeader(
          currentAccountPicture: Image.network(model.user.profileImg),
          accountName:
              Text(model.user.firstNameEn + '  ' + model.user.lastNameEn),
          accountEmail: Text(model.user.branchName)),
    );
