
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../../../view_model/profile_view_model.dart';
import '../../widget/diet_schedule/message.dart';
import '../../widget/user/user_profile_completed_days.dart';
import '../authentication/authentication_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

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

        return Message(text: '¿Seguro desea cerrar sesión?', yesFunction: (){
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
          // Provider.of<UserProvider>(context, listen: false).logOut();

        }, noFunction: (){}, options: true,);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
    return SizedBox(
      height: size.height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 85, width: size.width, color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                              border: Border.all(
                                color: primaryColor,
                                width: 4,
                              ),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.account_circle, size: 50, color: primaryColor,),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(UserSession().userLastName),
                              Text(UserSession().userFirstName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const Spacer(),
                          Align(
                              alignment: Alignment.topRight,
                              child: Ink(
                                  child: InkWell(
                                      onTap: (){
                                        _showDialog();
                                      },
                                      child: const FaIcon(FontAwesomeIcons.signOutAlt, color: primaryColor)
                                  )
                              )
                          )
                        ],
                      ),
                    ),
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
                              const FaIcon(FontAwesomeIcons.personBooth, color: Color(0xFFFFAC33), size: 40,),
                              Text(UserSession().activePatients.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                              const Text('Pacientes', style: TextStyle(fontSize: 10.5))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              UserSession().rol == "p" ? Container(
                margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                height: size.height/1.8,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child:  Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.balanceScale, color: primaryColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Balance consumido', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
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
                          primary: const Color(0xFF20D0CE),
                          fixedSize: const Size(350.0, 20.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.arrow_back_ios_rounded),
                            Text('Carbohidratos', style: TextStyle(fontSize: 12),),
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
                          primary: chartTitleCardColor,
                          fixedSize: const Size(350.0, 20.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.arrow_back_ios_rounded),
                            Text('Proteinas', style: TextStyle(fontSize: 12),),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height / 5.5,
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
                                interval: 50,
                                decimalPlaces: 1,
                                labelFormat: '{value} kcal',
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
                                interval: 50,
                                decimalPlaces: 1,
                                labelFormat: '{value} kcal',
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.weight, color: primaryColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Evolución del Peso', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height / 4.5,
                      child: SfCartesianChart(
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
                          minimum: 50,
                          maximum: 100,
                          interval: 10,
                          decimalPlaces: 1,
                          labelFormat: '{value} Kg',
                          labelStyle: GoogleFonts.lato(),
                        ),
                        series: <ChartSeries> [
                          LineSeries<WeightData, String>(
                            dataSource: Provider.of<ProfileViewModel>(context, listen: false).getWeightHistory(),
                            yValueMapper: (WeightData weight, _) => weight.lostWeight,
                            xValueMapper: (WeightData weight, _) => weight.month.toString(),
                            color: chartLineColor,
                            width: 2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ) : Container(
                margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                height: size.height/1.8,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child:  Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.qrcode, color: primaryColor, size: 12,),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Codigo de registro', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
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
                          activeColor: Colors.grey,
                          inactiveColor: Colors.grey,
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
                                  colors: [primaryColor, Color(0xFFFE7EB4)],
                                  stops: [0.05, 1]
                              )
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              // await Provider.of<UserProvider>(context, listen: false).generateAccessCode().then((value){
                              //   setState(() {
                              //     pinController.text = value;
                              //   });
                              // });
                            },
                            child: Icon(CupertinoIcons.refresh, color: Colors.white, size: size.height/20,),
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
                    )
                  ],
                ),
              ),
              const SizedBox(height: 200,)
            ],
          );
        },
      ),
    );
  }
}


