



import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/entities/user_session.dart';


class UserProvider with ChangeNotifier {

  bool messagesReady = false;

  setMessagesReady(bool newState){
    messagesReady = newState;
    notifyListeners();
  }

  logOut(ChatViewModel _chatViewModel){
    UserSession().logOut();
    _chatViewModel.client.disconnectUser();
  }

}