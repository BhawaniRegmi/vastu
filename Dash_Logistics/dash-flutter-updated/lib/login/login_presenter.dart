

import 'package:logistics/api/LoginApi.dart';
import 'package:logistics/data/rest_ds.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(LoginResponse response);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  LoginApiService loginApiService = new LoginApiService();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async{
    if(username.isEmpty)
      _view.onLoginError("email must not be empty");
    else if(password.isEmpty)
      _view.onLoginError("password must not be empty");
    else {
      try {
        LoginResponse response = await loginApiService.login(username, password);
        if (response.error != null) {
          _view.onLoginError(response.error[0].title);
        }
        else {
          _view.onLoginSuccess(response);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', response.data.accessToken);
          var currentTime =  DateTime.now().millisecondsSinceEpoch;
          var expiresIn = response.data.expiresIn * 1000;
          prefs.setInt('expireIn', currentTime + expiresIn);
        }
      }
      catch (e) {
        _view.onLoginError("something went wrong");
      }
    }
  }
}


