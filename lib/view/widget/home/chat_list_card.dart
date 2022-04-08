import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_feed_app/providers/user_provider.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../util/colors.dart';


class ChatListCard extends StatefulWidget {
  final ChatViewModel chatViewModel;
  const ChatListCard({Key? key, required this.chatViewModel}) : super(key: key);

  @override
  _ChatListCardState createState() => _ChatListCardState();
}

class _ChatListCardState extends State<ChatListCard> {

  late DateFormat format;

  @override
  void initState() {
    format = DateFormat('EEEE HH:mm');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height / 3,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            chatCardPrimaryColor,
            chatCardSecondaryColor,
          ],
          stops: [0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.005),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(-5, -5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width/30, vertical: size.height/80),
        child: Column(
          children: [
            Row(
              children: const [
                FaIcon(FontAwesomeIcons.facebookMessenger, size: 15,),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Conversaciones", style: TextStyle(fontWeight: FontWeight.bold),),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height/80),
              child: Provider.of<UserProvider>(context).messagesReady == false ?
              const Center(
                child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)),
              ) : widget.chatViewModel.getLastMessages().isNotEmpty ?
              Column(
                children: List.generate(widget.chatViewModel.getLastMessages().length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(widget.chatViewModel.getLastMessages()[index].user!.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                const SizedBox(width: 10),
                                CircleAvatar(backgroundColor: Colors.black, radius: 5,)
                              ],
                            ),
                            Text(format.format(widget.chatViewModel.getLastMessages()[index].createdAt), style: const TextStyle(fontSize: 10, color: Colors.white),),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            width: size.width,
                            height: 30,
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(15.0))
                            ),
                            child: Text(widget.chatViewModel.getLastMessages()[index].text!, style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ) :
              const Center(
                  child: Text("No tiene mensajes pendientes", style: TextStyle(color: Colors.white),))
            )
          ],
        ),
      ),
    );
  }
}