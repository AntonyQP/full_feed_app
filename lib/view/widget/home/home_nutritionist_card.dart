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
      width: size.width / 2.2,
      height: size.height / 4.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Color(0xFFDFE7FC),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(13, 18, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Nutricionista', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: size.width/30),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Color(0xFFDFE7FC),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                //TODO: necesita lógica si el experto tiene o no una foto, se requiere condicional de poner un ícono de usuario o imagen
                child: const Icon(Icons.account_circle, size: 30, color: Colors.grey,),
              ),),
              Padding(padding: EdgeInsets.only(left: size.width/60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Doctor', style: TextStyle(fontSize: 12)),
                  Text(Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.firstName.toString(), style: const TextStyle(fontSize: 12),)
                ],
              ),)
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.chat_bubble_2_fill, size: 12,),
                    Text('  Último mensaje', style: TextStyle(fontSize: 11),)
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
                height: 25.0,
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
          ) : const Align(
            alignment: Alignment.center,
            child: Text('No tiene mensajes pendientes', style: TextStyle(fontSize: 10, color: Colors.grey),),)
        ],
      ),
    );
  }
}


