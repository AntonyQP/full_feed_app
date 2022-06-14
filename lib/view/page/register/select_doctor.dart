
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/doctor.dart';
import '../../widget/authentication/dropdown.dart';

class Option{
  int id;
  String name;

  Option(this.id, this.name);

}

class SelectDoctorScreen extends StatefulWidget {

  final Function goToUserLikes;
  const SelectDoctorScreen({Key? key, required this.goToUserLikes}) : super(key: key);

  @override
  SelectDoctorScreenState createState() => SelectDoctorScreenState();
}

class SelectDoctorScreenState extends State<SelectDoctorScreen>{

  late TextEditingController pinController;
  late Future<List<Doctor>> _future;
  int _cantError = 3;
  bool error = false;

  @override
  void initState() {
    pinController = TextEditingController();
    _future = Provider.of<RegisterViewModel>(context, listen: false).getDoctors();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height/30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: ListView(
                children: [
                  const Text("Seleccione un doctor", textAlign: TextAlign.start, style: TextStyle(fontSize: 13),),
                  Container(
                    height: size.height/20,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(1, 4),
                          ),
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: FutureBuilder<List<Doctor>>(
                        future: _future,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data!.isNotEmpty){
                              return DropDown(hintText: "Doctor", datos: snapshot.data!.map<DropdownMenuItem<Doctor>>((Doctor item){
                                return DropdownMenuItem<Doctor>(
                                  child: Text(item.user!.firstName.toString()),
                                  value: item,
                                );
                              }).toList(), initialValue: snapshot.data![0].doctorId);
                            }
                            else{
                              return const Text("No hay doctores");
                            }
                          }
                          else{
                            return const Center(
                              child: Text("Cargando doctores", style: TextStyle(color: Colors.grey, fontSize: 12),),
                            );
                          }
                        },
                      )
                    ),
                  ),
                  SizedBox(height: size.height/80,),
                  const Text("Ingrese el codigo generado por el doctor para continuar con el registro", textAlign: TextAlign.center, style: TextStyle(fontSize: 13),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width/10),
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
                        Provider.of<RegisterViewModel>(context, listen: false).validateAccessCode().then((value){
                          if(value){
                            widget.goToUserLikes();
                          }
                          else{
                            setState(() {
                              error = true;
                              _cantError--;
                            });
                            pinController.clear();
                          }
                        });
                      },
                      onChanged: (value) {
                        Provider.of<RegisterViewModel>(context, listen: false).setAccessCode(value);
                      },
                      beforeTextPaste: (text) {

                        return true;
                      },
                    ),
                  ),
                  Visibility(
                    visible: error,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("El codigo no coincide con el codigo generado por el doctor"),
                        Text("$_cantError intentos restantes")
                      ],
                    ),
                  )
                ].map((children) =>
                    Padding(padding: const EdgeInsets.fromLTRB(20, 15, 20,15),
                        child: children)).toList(),
              ),
            ),
        ],
      ),);
  }
}
