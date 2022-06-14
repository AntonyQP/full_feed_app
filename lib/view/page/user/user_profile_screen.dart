
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_feed_app/util/util.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/entities/user_session.dart';
import '../../../view/widget/user/user_profile_weight.dart';
import '../../../util/colors.dart';
import '../../../view_model/illness_list_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import '../../widget/diet_schedule/message.dart';
import '../../widget/user/user_profile_completed_days.dart';
import '../authentication/authentication_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final Function logOut;
  const UserProfileScreen({Key? key, required this.logOut}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class GoToPage {
  static const int carbohydrates = 0;
  static const int proteins = 1;
}

class _UserProfileScreenState extends State<UserProfileScreen> with
    AutomaticKeepAliveClientMixin{

  bool isPressed = false;
  final PageController _pageController = PageController(initialPage: GoToPage.carbohydrates);
  final TextEditingController pinController = TextEditingController();

  String _state = "";
  Color _colorState = Colors.white;

  void _switchPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear
    );
  }

  _showDialog(){
    showDialog(
      barrierColor: Colors.white70,
      context: context,
      builder: (BuildContext context) {

        return Message(text: '¿Seguro desea cerrar sesión?',
          advice: '',
          yesFunction: (){
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const AuthenticationScreen()
              )
          );
          widget.logOut();

        }, noFunction: (){
          Navigator.pop(context);
        }, options: true,);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setValue(UserSession().bmi);
  }


  setValue(double imc){
    if (imc >= 40.0) {
      setState(() {
        _colorState = fatIIIWeightColor;
        _state = "OBESIDAD III";
      });
    }
    if (imc < 39.9 && imc >= 35.0) {
      setState(() {
        _colorState = fatIIWeightColor;
        _state = "OBESIDAD II";
      });
    }
    if (imc < 34.9 && imc >= 30.0) {
      setState(() {
        _colorState = fatIWeightColor;
        _state = "OBESIDAD I";
      });
    }
    if (imc < 30.0 && imc >= 25.0) {
      setState(() {
        _colorState = Color(0XFFFF295D);
        _state = "SOBREPESO";
      });
    }
    if (imc < 24.9 && imc >= 18.5) {
      setState(() {
        _colorState = Color(0XFF02D871);
        _state = "NORMAL";
      });
    }
    if (imc < 18.5) {
      setState(() {
        _colorState = Color(0XFFFFEA29);
        _state = "BAJO PESO";
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;

    final patientIllnessesList = Provider.of<IllnessListViewModel>(context, listen: false).getPatientIllnesses();

    return SizedBox(
      height: size.height,
      child: ListView(
        children: [
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: UserSession().sex == 'h' ? AssetImage('assets/male_user.jpg') : AssetImage('assets/female_user.jpg'),
                  ),
                  const SizedBox(height: 10.0),
                  Text(UserSession().userLastName),
                  Text(UserSession().userFirstName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
              Positioned(
                right: 20,
                child: Row(
                  children: [
                    Visibility(
                      visible: isPatient(),
                      child: Ink(
                          child: InkWell(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: const Text('Enfermedades'),
                                        content: SizedBox(
                                          height: 100,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: patientIllnessesList.map((e) => Text('- ${e.name!}',
                                                style: const TextStyle(color: Colors.black),
                                              )).toList(),
                                            ),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0)
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: (){ Navigator.pop(context); },
                                            child: const Text('Volver', style: TextStyle(color: Colors.white),),
                                            style: ElevatedButton.styleFrom(
                                              primary: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25.0)
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              child: const FaIcon(FontAwesomeIcons.archive, color: chatCardPrimaryColor)
                          )
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Ink(
                        child: InkWell(
                            onTap: (){
                              _showDialog();
                            },
                            child: const Icon(Icons.settings, color: darkColor)
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              color: Colors.white,
              gradient: RadialGradient(
                colors: [
                  cardColor,
                  Colors.white.withOpacity(0.6),
                ],
                stops: [0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.005),
                  spreadRadius: 1,
                  blurRadius: 12,
                  offset: const Offset(-5, -5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120, width: size.width, color: Colors.transparent,
                  child: isPatient() ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CompletedDaysItem(
                          completedDays: UserSession().successfulDays.toString()
                      ),
                      const SizedBox(width: 25),
                      LostWeightItem(
                          lostWeight: UserSession().lossWeight.toString()
                      )
                    ],
                  ) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.accessibility_new_rounded, color: Color(0xFFFFAC33), size: 40,),
                          Text(UserSession().activePatients.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                          const Text('Pacientes', style: TextStyle(fontSize: 10.5))
                        ],
                      )
                    ],
                  ),
                ),
                isPatient() ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child:  Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.infoCircle, color: darkColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Resumen de datos', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  gradient: RadialGradient(
                                    colors: [
                                      cardColor,
                                      Colors.white.withOpacity(0.4),
                                    ],
                                    stops: [0.5, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.005),
                                      spreadRadius: 1,
                                      blurRadius: 12,
                                      offset: const Offset(-5, -5),
                                    )
                                  ],
                                ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset('assets/bmi_icon.svg', height: 15, color: darkColor,),
                                      Text(UserSession().bmi.toStringAsFixed(1),  style: TextStyle(fontSize: 12))
                                    ],
                                  )
                              ),
                              SizedBox(height: 15,),
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  gradient: RadialGradient(
                                    colors: [
                                      cardColor,
                                      Colors.white.withOpacity(0.4),
                                    ],
                                    stops: [0.5, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.005),
                                      spreadRadius: 1,
                                      blurRadius: 12,
                                      offset: const Offset(-5, -5),
                                    )
                                  ],
                                ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset('assets/hip_icon.svg', height: 15, color: darkColor,),
                                      Text(UserSession().tmb.toStringAsFixed(1),  style: TextStyle(fontSize: 12))
                                    ],
                                  )
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  gradient: RadialGradient(
                                    colors: [
                                      cardColor,
                                      Colors.white.withOpacity(0.4),
                                    ],
                                    stops: [0.5, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.005),
                                      spreadRadius: 1,
                                      blurRadius: 12,
                                      offset: const Offset(-5, -5),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset('assets/arm_icon.svg', height: 15, color: darkColor,),
                                    Text(UserSession().arm.toStringAsFixed(1),  style: TextStyle(fontSize: 12))
                                  ],
                                )
                              ),
                              SizedBox(height: 15,),
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  gradient: RadialGradient(
                                    colors: [
                                      cardColor,
                                      Colors.white.withOpacity(0.4),
                                    ],
                                    stops: [0.5, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: const Offset(5, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.005),
                                      spreadRadius: 1,
                                      blurRadius: 12,
                                      offset: const Offset(-5, -5),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset('assets/abdominal_icon.svg', height: 15, color: darkColor,),
                                    Text(UserSession().abdominal.toStringAsFixed(1), style: TextStyle(fontSize: 12),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SvgPicture.asset('assets/normal_person.svg', height: size.height * 0.15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: size.height * 0.04,
                                backgroundColor: _colorState,
                                child: Center(
                                  child: Text(_state, style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center,),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('${UserSession().height.toStringAsFixed(1)} cm',  style: TextStyle(fontSize: 12)),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('${UserSession().weight.toStringAsFixed(1)} kg',  style: TextStyle(fontSize: 12))
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child:  Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.balanceScale, color: darkColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Balance consumido', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: isPressed == false ?
                      ElevatedButton(
                        onPressed: (){
                          _switchPage(GoToPage.proteins);
                          isPressed = !isPressed;
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          fixedSize: const Size(350.0, 20.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.arrow_back_ios_rounded),
                            Text('Carbohidratos (kcal)', style: TextStyle(fontSize: 12),),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ) : ElevatedButton(
                        onPressed: (){
                          _switchPage(GoToPage.carbohydrates);
                          isPressed = !isPressed;
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: chatCardPrimaryColor,
                          fixedSize: const Size(350.0, 20.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.arrow_back_ios_rounded),
                            Text('Proteinas (kcal)', style: TextStyle(fontSize: 12),),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.2,
                      child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          children: [
                            SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true),
                              tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: true),
                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                labelPlacement: LabelPlacement.betweenTicks,
                                interval: 1,
                                labelStyle: GoogleFonts.lato(),
                              ),
                              primaryYAxis: NumericAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                minimum: 0,
                                maximum: 500,
                                interval: 100,
                                decimalPlaces: 1,
                                labelFormat: '{value}',
                                labelStyle: GoogleFonts.lato(),
                              ),
                              series: <CartesianSeries> [
                                ColumnSeries<CarbohydrateData, String>(
                                  dataSource: Provider.of<ProfileViewModel>(context, listen: false).getCarbohydrateChartData(),
                                  yValueMapper: (CarbohydrateData carbohydrate, _)
                                  => carbohydrate.kCal,
                                  xValueMapper: (CarbohydrateData carbohydrate, _)
                                  => carbohydrate.days.toString(),
                                  color: columnChartColor,
                                  width: 0.5,
                                ),
                              ],
                            ),
                            SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true),
                              tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: true),
                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                labelPlacement: LabelPlacement.betweenTicks,
                                interval: 1,
                                labelStyle: GoogleFonts.lato(),
                              ),
                              primaryYAxis: NumericAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                minimum: 0,
                                maximum: 500,
                                interval: 100,
                                decimalPlaces: 1,
                                labelFormat: '{value}',
                                labelStyle: GoogleFonts.lato(),
                              ),
                              series: <CartesianSeries> [
                                ColumnSeries<ProteinData, String>(
                                  dataSource: Provider.of<ProfileViewModel>(context, listen: false).getProteinChartDataToShow(),
                                  yValueMapper: (ProteinData protein, _) => protein.kCal,
                                  xValueMapper: (ProteinData protein, _) => protein.days.toString(),
                                  color: columnChartColor,
                                  width: 0.5,
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.weight, color: darkColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Evolución del Peso', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true),
                        tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: true),
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          labelPlacement: LabelPlacement.betweenTicks,
                          interval: 1,
                          labelStyle: TextStyle(fontSize: 10,),
                        ),
                        primaryYAxis: NumericAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          minimum: 50,
                          maximum: 100,
                          interval: 10,
                          decimalPlaces: 1,
                          labelFormat: '{value}',
                          labelStyle: GoogleFonts.lato(),
                        ),
                        series: <ChartSeries> [
                          LineSeries<WeightData, String>(
                            dataSource: Provider.of<ProfileViewModel>(context, listen: false).getWeightHistory(),
                            yValueMapper: (WeightData weight, _) => weight.lostWeight,
                            xValueMapper: (WeightData weight, _) => weight.month.toString(),
                            color: darkColor,
                            width: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ) : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child:  Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.qrcode, color: darkColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Codigo de registro', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/15, right: size.width/15, top: size.height/20),
                      child: PinCodeTextField(
                        length: 5,
                        appContext: context,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          selectedFillColor: Colors.white,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white,
                          selectedColor: primaryColor,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 45,
                          fieldWidth: 40,

                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        controller: pinController,
                        onCompleted: (v) {

                        },
                        onChanged: (value) {
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: size.height/50),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                  stops: [0.05, 1]
                              )
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await Provider.of<ProfileViewModel>(context, listen: false).generateAccessCode().then((value){
                                setState(() {
                                  pinController.text = value;
                                });
                              });
                            },
                            child: Icon(Icons.confirmation_number_outlined, color: Colors.white, size: size.height/20,),
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size( 100,  100),
                              elevation: 0,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.transparent, // <-- Button color
                              onPrimary: Colors.transparent, // <-- Splash color
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: size.height * 0.05,)
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.15,)
        ],
      ),
    );
  }
}


