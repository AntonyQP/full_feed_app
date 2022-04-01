



import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entities/user_session.dart';


class UserProvider with ChangeNotifier {

  // late RegisterPresenter registerPresenter;
  // late LoginPresenter loginPresenter;
  // late ProfilePresenter profilePresenter;
  // late ChatPresenter chatPresenter;
  // Util util = Util();
  // String email = "";
  // String password = "";

  // initRegisterPresenter(BuildContext _context){
  //   registerPresenter = RegisterPresenter(_context);
  // }
  //
  // initLoginPresenter(BuildContext _context){
  //   loginPresenter = LoginPresenter(_context);
  // }
  //
  // initChatPresenter(BuildContext _context){
  //   chatPresenter = ChatPresenter(_context);
  // }
  //
  // initProfilePresenter(BuildContext _context){
  //   profilePresenter = ProfilePresenter(_context);
  // }

  // setMessages(bool _ready){
  //   chatPresenter.messagesReady = _ready;
  //   notifyListeners();
  // }
  //
  // setEmail(String _email){
  //   email = _email;
  // }
  //
  // setPassword(String _password){
  //   password = _password;
  // }
  //
  //
  // getCredentials() async {
  //   final SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   email = _prefs.getString("full_feed_email") ?? "";
  //   password = _prefs.getString("full_feed_password") ?? "";
  // }
  //
  //
  //
  logOut(ChatViewModel _chatViewModel){
    UserSession().logOut();
    _chatViewModel.client.disconnectUser();
  }

}