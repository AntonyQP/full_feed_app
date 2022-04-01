import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/login_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../widget/authentication/login_button.dart';
import '../../widget/authentication/register_button.dart';
import 'login_validate.dart';


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;

  @override
  void initState() {
    super.initState();
  }

  void _togglePassword() {
    isHiddenPassword = !isHiddenPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: primaryColor,
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: size.height*0.15,
                child: Image.asset(
                    'assets/fullfeedwhite.png',
                    height: 150, width: 150,
                    fit: BoxFit.fill
                )
            ),
            Positioned(
              top: size.height*0.45, bottom: 10, left: 10, right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: ListView(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: size.width/30, bottom: size.height/80),
                            child: const Text('Correo', style: TextStyle(color: Color(0XFF7B7B7B)),),),
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
                                  //initialValue: Provider.of<UserProvider>(context, listen: false).email,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: 'example@example.com',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onSaved: (value){
                                    Provider.of<LoginViewModel>(context, listen: false).setUserLoginDto('email', value!);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese un correo";
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: EdgeInsets.only(left: size.width/30, bottom: size.height/80),
                              child: Text('Contraseña', style: TextStyle(color: Color(0XFF7B7B7B)),),),
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
                              child: TextFormField(
                                //initialValue:  Provider.of<UserProvider>(context, listen: false).password,
                                onSaved: (value){
                                  Provider.of<LoginViewModel>(context, listen: false).setUserLoginDto('password', value!);
                                },
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    suffixIcon: InkWell(
                                      child: isHiddenPassword == true
                                          ? const Icon(Icons.visibility, size: 20, color: primaryColor,)
                                          : const Icon(Icons.visibility_off, size: 20, color: primaryColor,),
                                      onTap: _togglePassword,
                                    )
                                ),
                                obscureText: isHiddenPassword,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese una contraseña";
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width/20),
                              child: LoginButton(press: (){
                                var isValid = _formKey.currentState!.validate();
                                if (isValid) {
                                  _formKey.currentState!.save();
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: const Duration(milliseconds: 200),
                                          reverseDuration: const Duration(milliseconds: 200),
                                          type: PageTransitionType.rightToLeft,
                                          child: const LoginValidate()
                                      )
                                  );
                                }
                              },),),
                            //ForgotPasswordButton(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width/20, vertical: size.height/80),
                              child: RegisterButton(),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}