import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';


class ChatListItem extends StatefulWidget {
  final int index;
  final String title;
  final String name;
  const ChatListItem({Key? key, required this.index, required this.title, required this.name}) : super(key: key);

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
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: widget.index == 0 ? primaryColor : Color(0xFFDCDCDC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))
              ),
              width: size.width * 0.85,
            ),
          ),
          Positioned(
            left: size.width * 0.1,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/breakfast_back.png'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width/20, vertical: size.height/40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.title, style: TextStyle(
                          color: widget.index == 0 ?  Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                          fontSize: 12),),
                      Text(widget.name, style: TextStyle(
                          color: widget.index == 0 ?  Colors.white : Colors.black.withOpacity(0.7), fontWeight:
                          FontWeight.bold, fontSize: 14),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
