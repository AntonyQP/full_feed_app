import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/model/entities/patient.dart';
import 'package:full_feed_app/model/entities/user_session.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../util/util.dart';

class ChatViewModel{


  final List<Channel> _userChannels = [];
  final List<Message> _lastMessages = [];
  bool _messagesReady = false;
  late StreamChatClient client;

  ChatViewModel(BuildContext _context){
    client = StreamChat.of(_context).client;
  }

  getMessagesReady(){
    return _messagesReady;
  }

  List<Channel> getUserChannels(){
    return _userChannels;
  }

  Future<void> initUser(int? doctorId, List<Patient> patientsChat) async{
    await client.connectUser(
      User(
          id: UserSession().userId.toString(),
          extraData: {
            "name" : UserSession().userFirstName
          }
      ),
      client.devToken(UserSession().userId.toString()).rawValue,).whenComplete((){
      initChannels(doctorId, patientsChat);
    });
  }

  initChannels(int? doctorId, List<Patient> patientsChat){
    if(isPatient()){
      _userChannels.add(client.channel('messaging', id: "doctor${doctorId.toString()}patient${UserSession().userId.toString()}"));
    }
    else{
      for(int i = 0; i < patientsChat.length; i++){
        _userChannels.add(client.channel('messaging', id: "doctor${UserSession().userId.toString()}patient${patientsChat[i].user!.userId.toString()}"));
      }
    }
    //setLastMessages();
  }

  List<Message> getLastMessages(){
    return _lastMessages;
  }

  setLastMessages() async{
    for(int i = 0; i < _userChannels.length; i++){
      await _userChannels[i].watch().then((value){
        if(value.messages.isNotEmpty){
          if(value.messages.last.user!.name != UserSession().userFirstName){
            _lastMessages.add(value.messages.last);
          }
        }

      });
      await _userChannels[i].stopWatching();
    }
  }

}