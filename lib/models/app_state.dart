import 'user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:untitled/services/oauth_service.dart';

class AppState extends Model {

  User user = User();
  String username;
  String password;
  String server;

  void getUser() async {
    var result = await OAuthService().getProfile();
    user = User.fromJson(result["responseRecord"]);
    notifyListeners();
  }

  void saveSetting(String username, String password, String server) {
    this.username = username;
    this.password = password;
    this.server = server;
    getUser();
  }

}