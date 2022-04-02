import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view/page/register/welcome_screen.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../widget/authentication/dropdown.dart';

class Option{
  int id;
  String name;

  Option(this.id, this.name);

}

class RolRegisterFormScreen extends StatefulWidget {

  final Function goToNextPage;
  const RolRegisterFormScreen({Key? key, required this.goToNextPage}) : super(key: key);

  @override
  RolRegisterFormScreenState createState() => RolRegisterFormScreenState();
}

class RolRegisterFormScreenState extends State<RolRegisterFormScreen> with
    AutomaticKeepAliveClientMixin{

  final GlobalKey<FormState> _rolFormKey = GlobalKey(debugLabel: 'ROL_REGISTER');
  final List<Option> _sexList = [Option(1, "Femenino"), Option(2, "Masculino")];
  final DateTime _startDate = DateTime.now();
  final TextEditingController _birthDayController = TextEditingController();

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              dialogTheme: const DialogTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              primaryColor: primaryColor,
              colorScheme: const ColorScheme.light(
                  primary: primaryColor),
              buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme
                      .primary), // This will change to light theme.
            ),
            child: child!,
          );
        },
        locale: Locale('en'),
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2025));
    if (picked != null && picked != _startDate) {
      setState(() {
        Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('birthDate', DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(picked));
        _birthDayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    super.build(context);
    return SizedBox(
      height: size.height,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: size.height/80, horizontal: 0),
        physics: const BouncingScrollPhysics(),
        children: [
          Form(
            key: _rolFormKey,
            child: Column(
              children: [
                Container(
                  height: size.height/20,
                  decoration: BoxDecoration(
                      color: Color(0XFFFAFAFA),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        )
                      ]
                  ),
                  child: DropDown(hintText: "Sexo", datos: _sexList.map<DropdownMenuItem<Option>>((Option item){
                    return DropdownMenuItem<Option>(
                      child: Text(item.name),
                      value: item,
                    );
                  }).toList(), initialValue: _sexList[0].id),
                ),
                Container(
                  height: size.height/20,
                  decoration: BoxDecoration(
                      color: Color(0XFFFAFAFA),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height/80),
                    child: TextField(
                      controller: _birthDayController,
                      readOnly: true,
                      onTap: () => selectStartDate(context),
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'Fecha de nacimiento',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)))),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                Provider.of<RegisterViewModel>(context, listen: false).getDesireRol() == "p" ? Container(
                  height: size.height/20,
                  decoration: BoxDecoration(
                      color: const Color(0XFFFAFAFA),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height/80),
                    child: TextFormField(
                        onSaved: (value){
                          Provider.of<RegisterViewModel>(context, listen: false).setHeight(double.parse(value!));
                          Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('height', double.parse(value));
                        },
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'cm',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)))),
                      textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese su altura ";
                          }
                        }
                    ),
                  ),
                ) : Container(
                  height: size.height/20,
                  decoration: BoxDecoration(
                      color: Color(0XFFFAFAFA),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height/80),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState(() {
                          Provider.of<RegisterViewModel>(context, listen: false).setDoctorRegisterDto('licenseNumber', value);
                        });
                      },
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'Código de nutricionista',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)))),
                      textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese su codigo de nutricionista";
                          }
                        }
                    ),
                  ),
                ),
                Visibility(
                  visible: Provider.of<RegisterViewModel>(context, listen: false).getDesireRol() == "p",
                  child: Container(
                    height: size.height/20,
                    decoration: BoxDecoration(
                        color: Color(0XFFFAFAFA),
                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          )
                        ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height/80),
                      child: TextFormField(
                        onSaved: (value){
                          Provider.of<RegisterViewModel>(context, listen: false).setWeight(double.parse(value!));
                          Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('weight', double.parse(value));
                        },
                          decoration: const InputDecoration(
                              hintText: 'kg',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)))),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese su peso ";
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ].map((children) =>
                  Padding(padding: const EdgeInsets.fromLTRB(25, 15, 25,15),
                      child: children)).toList(),
            ),
          ),
          SizedBox(height: size.height/2.3,),
          FloatingActionButton(
            onPressed: (){
              bool isValid = _rolFormKey.currentState!.validate();
              if(isValid){
                _rolFormKey.currentState!.save();
                if(Provider.of<RegisterViewModel>(context, listen: false).getDesireRol() == 'p'){
                  widget.goToNextPage();
                }
                else{
                  Provider.of<RegisterViewModel>(context, listen: false).registerDoctor().then((value){
                    if(value){
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.leftToRight,
                              child: const WelcomeScreen()
                          )
                      );
                    }
                  });
                }
              }
            },
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
          )
        ],
      ),
    );
  }
}
