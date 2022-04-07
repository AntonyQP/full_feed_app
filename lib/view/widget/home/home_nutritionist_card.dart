import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeNutritionistCard extends StatefulWidget {
  final ChatViewModel chatViewModel;
  const HomeNutritionistCard({Key? key, required this.chatViewModel}) : super(key: key);

  @override
  _HomeNutritionistCardState createState() => _HomeNutritionistCardState();
}

class _HomeNutritionistCardState extends State<HomeNutritionistCard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.35,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), topRight: Radius.circular(15.0),),
        gradient: LinearGradient(
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           colors: [chatCardPrimaryColor, chatCardSecondaryColor],
           stops: [0.4, 1]
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(13, 18, 13, 0),
            child: Align(
                alignment: Alignment.topRight,
                child: Text('Nutricionista', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
          ),
          const SizedBox(height: 10.0),
          CircleAvatar(
            radius: size.width * 0.1,
            backgroundImage: AssetImage('assets/breakfast_back.png')
            ),
          const SizedBox(height: 10.0),
          Text(Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.firstName.toString(),
            style: const TextStyle(fontSize: 14, color: Colors.white),),
          const SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: const [
                    Text('  Último mensaje', style: TextStyle(fontSize: 11, color: Colors.white),),
                    SizedBox(width: 5,),
                    Icon(CupertinoIcons.chat_bubble_2_fill, size: 12, color: Colors.white,),
                  ],
                )
            ),
          ),
          const SizedBox(height: 10.0),
          //TODO: Esqueleto de posible chat, es necesario proveer los mensajes, el lenght del mensaje y la última hora enviada
          widget.chatViewModel.getMessagesReady() && widget.chatViewModel.getLastMessages().isNotEmpty ?
          Column(
            children: [
              Container(
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.5)),
                    color: Color(0xFFE8EEFF),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: Text(widget.chatViewModel.getLastMessages()[0].text!, style: const TextStyle(fontWeight: FontWeight.w200)),
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(DateFormat('EEEE HH:mm').format(Provider.of<ChatViewModel>(context, listen: false).getLastMessages()[0].createdAt), style: const TextStyle(color: chatMessageTime, fontSize: 10))),
              )
            ],
          ) : Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: size.width * 0.3,
                child: Text('No tiene mensajes pendientes', style: TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center,)),)
        ],
      ),
    );
  }
}


