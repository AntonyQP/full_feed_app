import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view/widget/diet_schedule/doctor_patient.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/patient_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/patient.dart';
import 'diet_day_patient_detail.dart';

class DoctorPatientsList extends StatefulWidget {
  const DoctorPatientsList({Key? key}) : super(key: key);

  @override
  DoctorPatientsListState createState() => DoctorPatientsListState();
}

class DoctorPatientsListState extends State<DoctorPatientsList> with
    AutomaticKeepAliveClientMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text('Pacientes', style: TextStyle(fontSize: size.width/20, color: primaryColor, fontWeight: FontWeight.bold),),
              ),
              Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor().isNotEmpty ?
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: size.height/70),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 150),
                    itemCount: Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor().length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {

                      Patient _patient = Provider.of<LoggedInViewModel>(context).getPatientsByDoctor()[index];

                      return InkWell(
                        onTap: (){
                          Provider.of<PatientViewModel>(context, listen: false).setPatientSelected(_patient);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DietDayPatientDetail()),);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: size.height/80),
                          child: DoctorPatient(title: "Paciente", patient: _patient,),
                        ),
                      );
                    },
                  ),
                ),) : SizedBox(
                height: size.height * 0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.exclamationCircle, color: Colors.black26, size: size.width/10,),
                      const Text("Aun no tiene pacientes", style: TextStyle(color: Colors.black26),)
                    ],
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}
