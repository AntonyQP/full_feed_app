
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';

class Message extends StatefulWidget {

  final String text;
  final String advice;
  final Function yesFunction;
  final Function noFunction;
  final bool options;
  const Message({Key? key, required this.text, required this.advice, required this.yesFunction, required this.noFunction, required this.options}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      color: const Color.fromRGBO(255, 255, 255, 0.8),
      child: Padding(padding: EdgeInsets.symmetric(
          vertical: size.height/3.5, horizontal: size.width/20),
        child: SizedBox(
          width: 20,
          height: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width/1.5,
                child: Text(widget.text, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width/ 1.5,
                child: Text(widget.advice, style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width/8, vertical: size.height/30),
                child: Row(
                  mainAxisAlignment: widget.options ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: (){
                          widget.yesFunction();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(80, 80),
                          maximumSize: const Size(150, 150),
                          side: const BorderSide(
                              width: 2.0,
                              color: primaryColor
                          ),
                          shape: CircleBorder(),
                        ),
                        child: Text(widget.options ? 'Si' : "Ok", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),)),
                    Visibility(
                      visible: widget.options,
                      child: OutlinedButton(
                          onPressed: (){
                            widget.noFunction();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(80, 80),
                            maximumSize: Size(150, 150),
                            side: const BorderSide(
                                width: 2.0,
                                color: primaryColor
                            ),
                            shape: CircleBorder(),
                          ),
                          child: const Text('No', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}