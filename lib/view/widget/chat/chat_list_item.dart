import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatListItem extends StatefulWidget {
  final String title;
  final String name;
  const ChatListItem({Key? key, required this.title, required this.name}) : super(key: key);

  @override
  ChatListItemState createState() => ChatListItemState();
}

class ChatListItemState extends State<ChatListItem> with
    AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height/10,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width/20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.grey
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width/20, vertical: size.height/40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TextStyle(color: Colors.grey, fontSize: size.width/35),),
                Text(widget.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: size.width/25),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
