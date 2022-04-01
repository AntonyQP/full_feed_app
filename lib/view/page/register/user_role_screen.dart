import 'package:flutter/material.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../util/colors.dart';

class UserRoleScreen extends StatefulWidget {
  final VoidCallback goToNextPage;
  const UserRoleScreen({Key? key, required this.goToNextPage}) : super(key: key);

  @override
  _UserRoleScreenState createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> with
    AutomaticKeepAliveClientMixin{

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
                height: 50,
                child: Text('Descripcion del rol'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      color: primaryColor,
                      width: 3.0,
                    ),
                  ),
                  textStyle: const TextStyle(fontSize: 15),
                  primary: Provider.of<RegisterViewModel>(context).getDesireRol() == "p" ? primaryColor : Colors.white,
                  onPrimary: Colors.redAccent
                ),
                onPressed: () {
                  Provider.of<RegisterViewModel>(context, listen: false).setDesireRol("p");
                },
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
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      color: primaryColor,
                      width: 3.0,
                    ),
                  ),
                  textStyle: const TextStyle(fontSize: 15),
                  primary: Provider.of<RegisterViewModel>(context).getDesireRol() == "d" ? primaryColor : Colors.white,
                  onPrimary: Colors.redAccent
                ),
                onPressed: () {
                  Provider.of<RegisterViewModel>(context, listen: false).setDesireRol("d");
                },
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
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            onPressed: widget.goToNextPage,
            elevation: 1,
            child: Ink(
              width: 200,
              height: 200,
              decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                      colors: [primaryColor, Color(0xFFFF9FC8)],
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
