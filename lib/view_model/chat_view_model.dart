import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/model/entities/patient.dart';
import 'package:full_feed_app/model/entities/user_session.dart';
import 'package:full_feed_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../util/util.dart';

class ChatViewModel{


  final List<Channel> _userChannels = [];
  final List<Message> _lastMessages = [];
  int _messagesReady = 0;
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

  Future<void> initUser(String? doctorId, List<Patient> patientsChat) async{
    await client.connectUser(
      User(
          id: UserSession().dni,
          extraData: {
            "name" : UserSession().userFirstName
          }
      ),
      client.devToken(UserSession().dni).rawValue,).whenComplete((){
      initChannels(doctorId, patientsChat);
    });
  }

  initChannels(String? doctorId, List<Patient> patientsChat){
    if(isPatient()){
      _userChannels.add(client.channel('messaging', id: "d${doctorId.toString()}p${UserSession().dni}"));
    }
    else{
      for(int i = 0; i < patientsChat.length; i++){
        _userChannels.add(client.channel('messaging', id: "d${UserSession().dni}p${patientsChat[i].user!.dni}"));
      }
    }
  }

  List<Message> getLastMessages(){
    return _lastMessages;
  }

  Future<void> setLastMessages(BuildContext context) async{
    if(_userChannels.isNotEmpty){
      for(int i = 0; i < _userChannels.length; i++){
        await _userChannels[i].watch().then((value){
          if(value.messages.isNotEmpty){
            if(value.messages.last.user!.name != UserSession().userFirstName){
              _lastMessages.add(value.messages.last);
            }
          }
        });
        await _userChannels[i].stopWatching();
        if(i == _userChannels.length -1 ){
          Provider.of<UserProvider>(context, listen: false).setMessagesReady(true);
        }
      }
    }
    else{
      Provider.of<UserProvider>(context, listen: false).setMessagesReady(true);
    }
  }

}