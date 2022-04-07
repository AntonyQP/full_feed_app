
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/providers/patient_provider.dart';
import 'package:full_feed_app/view_model/patient_view_model.dart';
import 'package:provider/provider.dart';

import '../../../util/colors.dart';


class UpdatePatientDialog extends StatefulWidget {

  const UpdatePatientDialog({Key? key}) : super(key: key);

  @override
  UpdatePatientDialogState createState() => UpdatePatientDialogState();
}

class UpdatePatientDialogState extends State<UpdatePatientDialog> {
  double _height = 0.0;
  double _weight = 0.0;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey(debugLabel: 'UPDATE_PATIENT');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      color: const Color.fromRGBO(255, 255, 255, 0.8),
      child: Padding(padding: EdgeInsets.symmetric(
          vertical: size.height/4, horizontal: size.width/20),
        child: Container(
          width: size.width/1.5,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width/10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width/1.5,
                    child: const Text('Actualizar Datos de Paciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    height: size.height/30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Altura', style: TextStyle(fontSize: 14),),
                      Container(
                        width: size.width/2,
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
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            onSaved: (value){
                              setState(() {
                                _height = double.parse(value!);
                              });
                            },
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'm',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),)),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingrese la altura del paciente ";
                              }
                            }
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height/70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Peso', style: TextStyle(fontSize: 14),),
                      Container(
                        padding: EdgeInsets.zero,
                        width: size.width/2,
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
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            onSaved: (value){
                              setState(() {
                                _weight = double.parse(value!);
                              });
                            },
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'kg',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),)),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingrese el peso del paciente ";
                              }
                            }
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height/20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(100, 100),
                            maximumSize: const Size(150, 150),
                            side: const BorderSide(
                                width: 2.0,
                                color: Colors.blueGrey
                            ),
                            shape: CircleBorder(),
                          ),
                          child: Text('Cancelar', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),)
                      ),
                      OutlinedButton(
                          onPressed: (){
                            var isValid = formKey.currentState!.validate();
                            if(isValid){
                              formKey.currentState!.save();
                              Provider.of<PatientProvider>(context, listen: false).setPatientUpdating(true);
                              Provider.of<PatientViewModel>(context, listen: false).updatePatient(_height, _weight, context).whenComplete((){
                                Navigator.pop(context);
                                Provider.of<PatientProvider>(context, listen: false).setPatientUpdating(false);
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(100, 100),
                            maximumSize: const Size(150, 150),
                            side: const BorderSide(
                                width: 2.0,
                                color: primaryColor
                            ),
                            shape: const CircleBorder(),
                          ),
                          child: const Text('Actualizar', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height/10,
                  ),
                  Visibility(
                      visible: Provider.of<PatientProvider>(context).getIsPatientUpdating(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(color: primaryColor,),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}