import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../view/page/register/select_doctor.dart';
import '../../../view/page/register/loading_screen.dart';
import '../../../view/page/register/rol_register_form_screen.dart';
import '../../../view/page/register/user_allergies_screen.dart';
import '../../../view/page/register/user_likes_screen.dart';
import '../../../view/page/register/user_register_form_screen.dart';
import '../../../view/page/register/user_role_screen.dart';
import '../../../view/widget/authentication/register_steps_body.dart';
import '../../../view_model/register_view_model.dart';
import '../register/bmi_screen.dart';

class GoToPage {
  static const int role = 0;
  static const int userInfo = 1;
  static const int userRolForm = 2;
  static const int userBMI = 3;
  static const int selectDoctor = 4;
  static const int userLikes = 5;
  static const int userFoodAllergies = 6;
  static const int waitForDiet = 7;
}


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
      home: const RegisterUserForm(),
    );
  }
}

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({Key? key}) : super(key: key);

  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}


class _RegisterUserFormState extends State<RegisterUserForm> {

  final PageController pageController = PageController(initialPage: GoToPage.role);

  void switchPage(int page) {
    if(page == 5){
      Provider.of<RegisterViewModel>(context,listen: false).setLoggedIn(true);
    }
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear
    );
  }

  @override
  void initState() {
    Provider.of<RegisterViewModel>(context, listen: false).determineLocation();
    Provider.of<RegisterViewModel>(context, listen: false).setPreferencesLists();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          RegisterStepBody(
              title: 'Selecciona un rol',
              child: UserRoleScreen( goToNextPage: () { switchPage(GoToPage.userInfo); } ),
              fabOnPressed: (){ switchPage(GoToPage.userInfo); },
              arrowBackOnPressed: () { Navigator.of(context, rootNavigator: true).pop(); }
          ),
          RegisterStepBody(
              title: 'Datos personales',
              child: UserRegisterFormScreen( goToNextPage: () { switchPage(GoToPage.userRolForm); },),
              fabOnPressed: () {
                  // bool isValid = Provider.of<RegisterViewModel>(context, listen: false).validateUserFormKey();
                  // if(isValid){
                  //   Provider.of<RegisterViewModel>(context, listen: false).saveUserForm();
                  //   switchPage(GoToPage.userRolForm);
                  // }
                },
              arrowBackOnPressed: (){ switchPage(GoToPage.role); }
          ),
          RegisterStepBody(
              title: 'Datos personales',
              child: RolRegisterFormScreen(goToNextPage: (){ switchPage(GoToPage.userBMI); }, ),
              fabOnPressed: () {
                // bool isValid = Provider.of<RegisterViewModel>(context, listen: false).validateRolFormKey();
                // if(isValid){
                //   Provider.of<RegisterViewModel>(context, listen: false).saveRolForm();
                //   /*if(Provider.of<UserProvider>(context, listen: false).registerPresenter.desireRol == 2){
                //     Provider.of<UserProvider>(context, listen: false).registerPresenter.setDoctorRegisterDto();
                //     Provider.of<UserProvider>(context, listen: false).doctorRegister(Provider.of<UserProvider>(context, listen: false).registerPresenter.doctorRegisterDto).then((value){
                //       if(value){
                //         Navigator.pushReplacement(
                //             context,
                //             PageTransition(
                //                 duration: const Duration(milliseconds: 200),
                //                 reverseDuration: const Duration(milliseconds: 200),
                //                 type: PageTransitionType.leftToRight,
                //                 child: const WelcomeScreen()
                //             )
                //         );
                //       }
                //     });
                //   }else{
                //     switchPage(GoToPage.userBMI);
                //   }*/
                //   switchPage(GoToPage.userBMI);
                // }
              },
              arrowBackOnPressed: (){ switchPage(GoToPage.userInfo); }
          ),
          RegisterStepBody(
              title: 'Índice de Masa Corporal',
              child: BMIScreen( goToNexPage: () { switchPage(GoToPage.selectDoctor); }),
              fabOnPressed: () { switchPage(GoToPage.selectDoctor); },
              arrowBackOnPressed: (){ switchPage(GoToPage.userRolForm); }
          ),
          RegisterStepBody(
              title: 'Seleccione un doctor',
              child: SelectDoctorScreen(goToUserLikes: (){ switchPage(GoToPage.userLikes); }, ),
              fabOnPressed: () {
                switchPage(GoToPage.userLikes);
              },
              arrowBackOnPressed: (){ switchPage(GoToPage.userBMI); }
          ),
          RegisterStepBody(
              title: 'Comidas que te gustan',
              child: UserLikesScreen(type: "FAVORITE", goToNextPage: () { switchPage(GoToPage.userFoodAllergies); },),
              fabOnPressed: () {
                // Provider.of<UserProvider>(context, listen: false).registerPreferences(Provider.of<UserProvider>(context, listen: false).registerPresenter.preferencesFavorite).then((value){
                //   if(value){
                //     switchPage(GoToPage.userFoodAllergies);
                //   }
                // });
              },
              arrowBackOnPressed: (){Navigator.of(context, rootNavigator: true).pop();}
          ),
          RegisterStepBody(
              title: 'Alergias',
              child: UserAllergiesScreen(type: "ALLERGY", goToNextPage: () { switchPage(GoToPage.waitForDiet); },),
              fabOnPressed: () {
                // if(Provider.of<UserProvider>(context, listen: false).registerPresenter.preferencesAllergy.isNotEmpty){
                //   Provider.of<UserProvider>(context, listen: false).registerPreferences(Provider.of<UserProvider>(context, listen: false).registerPresenter.preferencesAllergy).whenComplete((){
                //     switchPage(GoToPage.waitForDiet);
                //   });
                // }
                // else{
                //   switchPage(GoToPage.waitForDiet);
                // }
              },
              arrowBackOnPressed: (){Navigator.of(context, rootNavigator: true).pop();}
          ),
          RegisterStepBody(
              title: '',
              child: const LoadingScreen(text: "Tu plan nutricional se esta generando...", generateDiet: true),
              fabOnPressed: () {},
              arrowBackOnPressed: (){}
          ),
        ],
      ),
    );
  }
}