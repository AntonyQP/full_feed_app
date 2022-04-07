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
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(logoImagePath, width: 40,
                            height: 40, fit: BoxFit.contain),
                        Image.asset(logoTextPath, width: 70,
                            height: 70, fit: BoxFit.contain)
                      ],
                    ),
                  ),
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
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white
                              ),
                              width: size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                          color: Color(0xFFFFBAB9),
                                        ),
                                        child: const Center(
                                          child: FaIcon(FontAwesomeIcons.user, color: Colors.white, size: 40,) ,
                                        ),
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
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFF20D0CE),
                                                      shape: BoxShape.circle
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () { _showDialog(); },
                                                    icon: Icon(Icons.edit),
                                                    color: Colors.white,
                                                    iconSize: 30,
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
                                    height: size.height/50,
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      PatientDetailCard(asset: "assets/height.svg", text: (_patientSelected.height! / 100).toStringAsFixed(2) + " m", title: "Altura"),
                                      PatientDetailCard(asset: "assets/weight.svg", text: _patientSelected.weight!.toStringAsFixed(2) + " kg", title: "Peso"),
                                      PatientDetailCard(asset: "assets/bmi.svg", text: _patientSelected.imc!.toStringAsFixed(2), title: "Imc"),
                                      PatientDetailCard(asset: "assets/age.svg", text: _patientSelected.age.toString(), title: "Edad")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height/50,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white
                              ),
                              width: size.width,
                              child: Column(
                                children: [
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
                                        primary: const Color(0xFF20D0CE),
                                        fixedSize: const Size(350.0, 15.0),
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
                                        elevation: 0,
                                        primary: chartTitleCardColor,
                                        fixedSize: const Size(350.0, 15.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Icon(Icons.arrow_back_ios_rounded),
                                          Text('Proteínas', style: TextStyle(fontSize: 12)),
                                          Icon(Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height/80,
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
                                                      labelFormat: '{value} kcal',
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
                                                      labelFormat: '{value} kcal',
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height/50,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white
                              ),
                              width: size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      FaIcon(FontAwesomeIcons.weight, color: primaryColor, size: 12,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Evolución del Peso', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                                      )
                                    ],
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
                                                  dataSource: snapshot.data!,
                                                  yValueMapper: (WeightData weight, _) => weight.lostWeight,
                                                  xValueMapper: (WeightData weight, _) => weight.month.toString(),
                                                  color: chartLineColor,
                                                  width: 2,
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
                            )
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
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white
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