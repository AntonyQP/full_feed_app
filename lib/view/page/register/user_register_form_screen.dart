import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class UserRegisterFormScreen extends StatefulWidget {

  final Function goToNextPage;
  const UserRegisterFormScreen({Key? key, required this.goToNextPage}) : super(key: key);

  @override
  UserRegisterFormScreenState createState() => UserRegisterFormScreenState();
}

class UserRegisterFormScreenState extends State<UserRegisterFormScreen> with
    AutomaticKeepAliveClientMixin{

  File? image;
  bool isHiddenPassword = true;
  final GlobalKey<FormState> _userFormKey = GlobalKey(debugLabel: 'USER_REGISTER');

  void _togglePassword() {
    isHiddenPassword = !isHiddenPassword;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final _temp = File(image.path);
      setState(() => this.image = _temp);
    } on PlatformException catch (error) {
      return null;
    }
  }

  @override
  bool get wantKeepAlive => true;

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
        children: [
          Form(
            key: _userFormKey,
            child: Flexible(
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 160, maxWidth: 140),
                    margin: const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 1.0),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          image != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            child: Image.file(
                              image!,
                              width: 125,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0))),
                              height: 120,
                              width: 125,
                              child: const Center(
                                  child: Icon(Icons.account_circle,
                                      size: 50.0, color: Colors.black38))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Añadir Foto',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white)),
                                const SizedBox(width: 5.0),
                                InkWell(
                                  child: const Icon(Icons.add_a_photo_rounded,
                                      size: 14.0, color: Colors.white),
                                  onTap: () async {
                                    pickImage(ImageSource.gallery);
                                  },
                                ),
                              ])
                        ]),
                  ),
                  Container(
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
                          Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('firstName', value);
                        },
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'Nombres',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese un nombre";
                          }
                        },
                      ),
                    ),
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
                      child: TextFormField(
                          onSaved: (value){
                            Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('lastName', value);
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Apellidos',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              )),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Ingrese un apellido";
                            }
                          }
                      ),
                    ),
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
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value){
                            Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('dni', value);
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'DNI',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              )),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Ingrese su dni";
                            }
                            if (value.length != 8) {
                              return "Ingrese un dni válido";
                            }
                          }
                      ),
                    ),
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
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (value){
                            Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('phone', value);
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Teléfono',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              )),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Ingrese su telefono";
                            }
                          }
                      ),
                    ),
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
                      child: TextFormField(
                          onSaved: (value){
                            Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('email', value);
                          },
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Correo',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(30.0))),),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Ingrese su correo";
                            }
                          }
                      ),
                    ),
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
                      child: TextFormField(
                          onSaved: (value){
                            Provider.of<RegisterViewModel>(context, listen: false).setUserRegisterDto('password', value);
                          },
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.grey),
                              hintText: 'Contraseña',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(bottom: size.height/80),
                                child: InkWell(
                                  child: isHiddenPassword == true
                                      ? const Icon(Icons.visibility, size: 20, color: Colors.redAccent,)
                                      : const Icon(Icons.visibility_off, size: 20, color: Colors.redAccent,),
                                  onTap: _togglePassword,
                                ),
                              )),
                          obscureText: isHiddenPassword,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Ingrese una contraseña";
                            }
                          }
                      ),
                    ),
                  ),
                ].map((children) =>
                    Padding(padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: children)).toList(),
              ),
            ),
          ),
          SizedBox(height: size.height/20,),
          FloatingActionButton(
            onPressed: (){
              bool isValid = _userFormKey.currentState!.validate();
              if(isValid){
                _userFormKey.currentState!.save();
                widget.goToNextPage();
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
        ]
      ),
    );
  }
}