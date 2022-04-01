
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_feed_app/view/page/chat/user_chat_page.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../util/colors.dart';
import '../../../util/util.dart';
import '../../widget/chat/chat_list_item.dart';


class ChatScreen extends StatefulWidget {
  final ChatViewModel chatViewModel;
  const ChatScreen({Key? key, required this.chatViewModel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with
    AutomaticKeepAliveClientMixin{

  var usersList = [];

  Future<void> goToUserChat(String firstName, String lastName, int index) async {
    Navigator.push(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
            type: PageTransitionType.rightToLeft,
            child: UserChatPage(firstName: firstName, lastName: lastName, channel: widget.chatViewModel.getUserChannels()[index],)
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Provider.of<LoggedInViewModel>(context).getPatientsByDoctor().isNotEmpty || isPatient() ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chats', style: TextStyle(fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),),
          !isPatient() ?
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 200),
              children: List.generate(Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor().length, (index) =>
                  InkWell(
                    onTap: (){
                      goToUserChat( Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor()[index].user!.firstName.toString(),
                          Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor()[index].user!.lastName.toString(),
                          index);
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height/80),
                        child: ChatListItem(title: "Paciente", name: Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor()[index].user!.firstName.toString(),)
                    ),
                  )
              ),
            ),
          ) : SizedBox(
            height: size.height,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                  onTap: (){
                    goToUserChat(Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.firstName.toString(),
                        Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.lastName.toString(),
                        0);
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/80),
                      child: ChatListItem(title: "Doctor", name: Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.firstName.toString(),)
                  ),
                ),
              ],
            ),
          )
        ],
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.exclamationCircle, color: Colors.black26, size: size.width/10,),
            SizedBox(
              width: size.width/2,
              child: const Text("Aun no tiene mensajes de sus pacientes", style: TextStyle(color: Colors.black26), textAlign: TextAlign.center,),
            )
          ],
        ),
      )
    );
  }
}
