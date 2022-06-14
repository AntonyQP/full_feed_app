import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_feed_app/model/entities/patient.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/util/strings.dart';
import 'package:full_feed_app/view/page/diet_schedule/update_patient_dialog.dart';
import 'package:full_feed_app/view_model/patient_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../../../domain/service/user_service.dart';
import '../../../model/entities/illness.dart';
import '../../../view_model/profile_view_model.dart';
import '../../widget/diet_schedule/patient_detail_card.dart';
import 'diet_calendar_page.dart';

class DietDayPatientDetail extends StatefulWidget {

  const DietDayPatientDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DietDayPatientDetailState();

}

class GoToPage {
  static const int carbohydrates = 0;
  static const int proteins = 1;
}

class DietDayPatientDetailState extends State<DietDayPatientDetail> {
  String date = "";
  int foodSelected = 0;
  int currentIndex = 0;
  bool created = true;

  bool isPressed = false;
  final PageController _pageController = PageController(initialPage: GoToPage.carbohydrates);
  late PageController _dietPageController;
  late var _futureConsumedBalance;
  late var _weightHistory;

  void _switchPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(seconds: 1),
        curve: Curves.linear
    );
  }

  updatePatient(){
    //widget.patient = Provider.of<DietProvider>(context, listen: false).homePresenter.getPatientAt(widget.patient.patientId!);
  }

  void _switchDietPage(int page) {
    _dietPageController.animateToPage(page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear
    );
  }


  @override
  void initState() {
    _dietPageController = PageController(initialPage: 0);
    _weightHistory = Provider.of<PatientViewModel>(context, listen: false).getWeightEvolutionOfSelectedPatient();
    _futureConsumedBalance = Provider.of<PatientViewModel>(context, listen: false).getConsumedBalanceOfSelectedPatient();
    super.initState();
  }

  _showDialog(){
    showDialog(
      barrierColor: Colors.white70,
      context: context,
      builder: (BuildContext context) {
        return const UpdatePatientDialog();
      },
    ).then((value){
      updatePatient();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: size.height/25, left: size.width/50, right: size.width/50),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {

              Patient _patientSelected = Provider.of<PatientViewModel>(context).getPatientSelected();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height*1.5,
                    child: PageView(
                      controller: _dietPageController,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back_ios_rounded, color: primaryColor),
                                    ),
                                    const Text("Volver", style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Plan Dietetico", style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),),
                                    IconButton(
                                      onPressed: () {
                                        _switchDietPage(1);
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor,),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                gradient: RadialGradient(
                                  colors: [
                                    cardColor,
                                    Colors.white.withOpacity(0.9),
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
                              width: size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: _patientSelected.user!.sex == 'h' ? AssetImage('assets/male_patient.jpg') : AssetImage('assets/female_patient.jpg'),
                                        radius: size.width * 0.09,
                                      ),
                                      const SizedBox(width: 20.0),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width/1.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(_patientSelected.user!.lastName.toString(), style: const TextStyle(fontWeight: FontWeight.w300),),
                                                    Text(_patientSelected.user!.firstName.toString(), style: const TextStyle(fontWeight: FontWeight.w300)),
                                                  ],
                                                ),
                                                FutureBuilder(
                                                    future: UserService().getPatientIllnessesByDoctor(_patientSelected.patientId!),
                                                    builder: (context, snapshot) {
                                                      return Container(
                                                        width: size.width * 0.1,
                                                        decoration: const BoxDecoration(
                                                            color: primaryColor,
                                                            shape: BoxShape.circle
                                                        ),
                                                        child: IconButton(
                                                          icon: const FaIcon(FontAwesomeIcons.headSideMask),
                                                          iconSize: size.width * 0.05,
                                                          padding: EdgeInsets.all(size.width * 0.005),
                                                          color: Colors.white,
                                                          onPressed: (){showDialog(
                                                              context: context,
                                                              builder: (context){
                                                                final _selectedPatientIllnessesList = snapshot.data as List<Illness>;
                                                                return AlertDialog(
                                                                  title: const Text('Enfermedades'),
                                                                  content: SizedBox(
                                                                    height: 100,
                                                                    child: SingleChildScrollView(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: _selectedPatientIllnessesList.map((e) => Text('- ${e.name!}',
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
                                                          );},
                                                        ),
                                                      );
                                                    }
                                                ),
                                                Container(
                                                width: size.width * 0.1,
                                                  decoration: const BoxDecoration(
                                                      color: chatCardPrimaryColor,
                                                      shape: BoxShape.circle
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () { _showDialog(); },
                                                    icon: Icon(Icons.edit),
                                                    color: Colors.white,
                                                    iconSize: size.width * 0.05,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: size.height/50),
                                            width: size.width/2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(_patientSelected.user!.email.toString(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 10)),
                                                Text(_patientSelected.user!.phone.toString(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 10)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      PatientDetailCard(asset: "assets/height.svg", text: (_patientSelected.height! / 100).toStringAsFixed(2) + " m", title: "Altura"),
                                      PatientDetailCard(asset: "assets/weight.svg", text: _patientSelected.weight!.toStringAsFixed(1) + " kg", title: "Peso"),
                                      PatientDetailCard(asset: "assets/bmi_icon.svg", text: _patientSelected.imc!.toStringAsFixed(2), title: "Imc"),
                                      PatientDetailCard(asset: "assets/arm_icon.svg", text: _patientSelected.arm!.toStringAsFixed(2), title: "Brazo"),
                                      PatientDetailCard(asset: "assets/abdominal_icon.svg", text: _patientSelected.abdominal!.toStringAsFixed(2), title: "Abdominal"),
                                      PatientDetailCard(asset: "assets/hip_icon.svg", text: _patientSelected.tmb!.toStringAsFixed(2), title: "Cadera")
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Row(
                                    children: const [
                                      FaIcon(FontAwesomeIcons.balanceScale, color: darkColor, size: 12,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Balance consumido', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
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
                                        elevation: 0,
                                        primary: primaryColor,
                                        fixedSize: const Size(350.0, 15.0),
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
                                        elevation: 0,
                                        primary: chatCardPrimaryColor,
                                        fixedSize: const Size(350.0, 15.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Icon(Icons.arrow_back_ios_rounded),
                                          Text('Proteínas (kcal)', style: TextStyle(fontSize: 12)),
                                          Icon(Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  SizedBox(
                                      width: size.width,
                                      height: size.height / 5.5,
                                      child: FutureBuilder<List>(
                                        future: _futureConsumedBalance,
                                        builder: (context, snapshot){
                                          if(snapshot.hasData && snapshot.data!.isNotEmpty){
                                            return PageView(
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
                                                      maximum: 250,
                                                      interval: 50,
                                                      decimalPlaces: 1,
                                                      labelFormat: '{value}',
                                                      labelStyle: GoogleFonts.lato(),
                                                    ),
                                                    series: <CartesianSeries> [
                                                      ColumnSeries<CarbohydrateData, String>(
                                                        dataSource: snapshot.data![0],
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
                                                      maximum: 250,
                                                      interval: 50,
                                                      decimalPlaces: 1,
                                                      labelFormat: '{value}',
                                                      labelStyle: GoogleFonts.lato(),
                                                    ),
                                                    series: <CartesianSeries> [
                                                      ColumnSeries<ProteinData, String>(
                                                        dataSource: snapshot.data![1],
                                                        yValueMapper: (ProteinData protein, _) => protein.kCal,
                                                        xValueMapper: (ProteinData protein, _) => protein.days.toString(),
                                                        color: columnChartColor,
                                                        width: 0.5,
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            );
                                          }
                                          else{
                                            return const Center(
                                              child: SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 3, color: primaryColor,),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Row(
                                    children: const [
                                      FaIcon(FontAwesomeIcons.weight, color: darkColor, size: 12,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Evolución del Peso', style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: size.width,
                                      child: FutureBuilder<List<WeightData>>(
                                        future: _weightHistory,
                                        builder: (context, snapshot){
                                          if(snapshot.hasData && snapshot.data!.isNotEmpty){
                                            return SfCartesianChart(
                                              plotAreaBorderWidth: 0,
                                              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true),
                                              tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: true),
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines: const MajorGridLines(width: 0),
                                                labelPlacement: LabelPlacement.betweenTicks,
                                                interval: 1,
                                                labelStyle: TextStyle(fontSize: 8),
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
                                                  dataSource: snapshot.data!,
                                                  yValueMapper: (WeightData weight, _) => weight.lostWeight,
                                                  xValueMapper: (WeightData weight, _) => weight.month.toString(),
                                                  color: darkColor,
                                                  width: 3,
                                                ),
                                              ],
                                            );
                                          }
                                          else{
                                            return const Center(
                                              child: SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 3, color: primaryColor,),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height/50,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _switchDietPage(0);
                                      },
                                      icon: const Icon(Icons.arrow_back_ios_rounded, color: primaryColor,),
                                    ),
                                    Text(_patientSelected.user!.firstName.toString(), style: const TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                gradient: RadialGradient(
                                  colors: [
                                    cardColor,
                                    Colors.white.withOpacity(0.9),
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
                              height: size.height/1.5,
                              width: size.width,
                              child: DietCalendarPage(patient: _patientSelected,),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )
      ),
    );
  }
}