import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../util/colors.dart';

class UserChatPage extends StatefulWidget {

  final String firstName;
  final String lastName;
  final Channel channel;
  const UserChatPage({Key? key, required this.firstName, required this.lastName, required this.channel}) : super(key: key);

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> with
    AutomaticKeepAliveClientMixin{

  late StreamChatClient client;
  bool isPressed = false;
  late Channel channel;


  @override
  void initState() {
    channel = widget.channel;
    channel.watch();
    super.initState();
  }

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
    return Scaffold(
      body: StreamChannel(
        channel: channel,
        child: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(-5, -5),
                  )
                ],
                gradient: RadialGradient(
                  colors: [
                    cardColor,
                    Colors.white.withOpacity(0.35),
                  ],
                  stops: [0.50, 1.0],
                ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: primaryColor
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              splashColor: Colors.white,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
                                    SizedBox(
                                      width: size.width/50,
                                    ),
                                    const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width/20, vertical: size.height/85),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.lastName, style: TextStyle(color: Colors.white, fontSize: size.width/35),),
                                  Text(widget.firstName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.width/25),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.1),
                    child: Column(
                      children: [
                        Expanded(
                          child: MessageListView(
                            messageHighlightColor: primaryColor,
                          ),
                        ),
                        MessageInput(
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
