import 'package:flutter/material.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../util/colors.dart';

class UserRoleScreen extends StatefulWidget {
  final Function goToNextPage;
  const UserRoleScreen({Key? key, required this.goToNextPage}) : super(key: key);

  @override
  _UserRoleScreenState createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> with
    AutomaticKeepAliveClientMixin{

  bool notValidated = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var size = MediaQuery.of(context).size;

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: size.height/20,
          child: Column(
            children: [
              //TODO: Change Text
              const SizedBox(
                height: 50,),
              InkWell(
                onTap: () {Provider.of<RegisterViewModel>(context, listen: false).setDesireRol("p");},
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: size.width * 0.8,
                  height: size.height * 0.20,
                  decoration: BoxDecoration(
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
                      gradient: Provider.of<RegisterViewModel>(context).getDesireRol() == "p" ?
                      const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [primaryColor, secondaryColor],
                          stops: [0.3, 1]
                      ) :
                      RadialGradient(
                        colors: [
                          cardColor,
                          Colors.white.withOpacity(0.35),
                        ],
                        stops: [0.50, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Text('Paciente', style: GoogleFonts.raleway(
                              color: Provider.of<RegisterViewModel>(context).getDesireRol() == "p" ? Colors.white : primaryColor,
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () {Provider.of<RegisterViewModel>(context, listen: false).setDesireRol("d");},
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: size.width * 0.8,
                  height: size.height * 0.20,
                  decoration: BoxDecoration(
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
                    gradient: Provider.of<RegisterViewModel>(context).getDesireRol() == "d" ?
                    const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [primaryColor, secondaryColor],
                        stops: [0.3, 1]
                    ) :
                    RadialGradient(
                      colors: [
                        cardColor,
                        Colors.white.withOpacity(0.6),
                      ],
                      stops: [0.50, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Text('Nutricionista', style: GoogleFonts.raleway(
                            color: Provider.of<RegisterViewModel>(context).getDesireRol() == "d" ? Colors.white : primaryColor,
                            fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Visibility(
                visible: notValidated,
                child: const Text('*Debe selecionar un rol para continuar.', style: TextStyle(fontSize: 14, color: Colors.red),),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            onPressed: (){
              if(Provider.of<RegisterViewModel>(context,listen: false).getDesireRol() != ""){
                setState(() {
                  notValidated = false;
                });
                widget.goToNextPage();
              }
              else{
                setState(() {
                  notValidated = true;
                });
              }
            },
            elevation: 1,
            child: Ink(
              width: 200,
              height: 200,
              decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      stops: [0.05, 1]
                  )
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 25),
            ),
          ),
        )
      ],
    );
  }
}
