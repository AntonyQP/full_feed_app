import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_feed_app/model/entities/patient_incomplete.dart';
import 'package:full_feed_app/providers/doctor_provider.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/util/util.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../domain/local/notification_service.dart';
import '../../../model/entities/user_session.dart';
import '../../../view_model/illness_list_view_model.dart';
import '../chat/chat_screen.dart';
import '../diet_schedule/diet_calendar_page.dart';
import '../diet_schedule/doctor_patients_list.dart';
import '../user/user_profile_screen.dart';
import 'home_page.dart';
import 'home_page_doctor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChatViewModel _chatViewModel;
  int currentIndex = 0;

  late var _future;

  listenNotifications() => NotificationService.onNotifications.stream.listen((event) { });

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.8),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          title: const Text('Alerta', textAlign: TextAlign.center, style: TextStyle(color: fatIIIWeightColor, fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Los siguientes usuarios no han marcado su ${setScheduleName(Provider.of<DoctorProvider>(context, listen: false).actualSchedule)}.', style: TextStyle(color: Colors.black, fontSize: 12)),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: List.generate(Provider.of<DoctorProvider>(context, listen: false).incompleteDietPatientList().length, (index){
                    PatientIncomplete patientIncomplete = Provider.of<DoctorProvider>(context, listen: false).incompleteDietPatientList()[index];
                    return Text('- ' + patientIncomplete.patientName!, style: TextStyle(fontSize: 12),);
                  }),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Revisar', style: TextStyle(color: chatCardPrimaryColor),),
              onPressed: () {
                Provider.of<DoctorProvider>(context, listen: false).setAlertChecked(true);
                Navigator.of(context).pop();
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _chatViewModel = ChatViewModel(context);

    if (isPatient()) {
      _future = Provider.of<LoggedInViewModel>(context, listen: false).setDoctorByPatient().whenComplete(() {
        Provider.of<ProfileViewModel>(context, listen: false).initPatientData().whenComplete(() {
          _chatViewModel.initUser(Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.dni, []).whenComplete((){
            _chatViewModel.setLastMessages(context).whenComplete((){
              Provider.of<IllnessListViewModel>(context, listen: false).populateIllnessesByPatient();
            });
          });
        });
      });
    }
    else{
      _future =  Provider.of<LoggedInViewModel>(context, listen: false).setPatientsByDoctor().whenComplete((){
        Provider.of<DoctorProvider>(context, listen: false).getIncompleteDietPatientList().whenComplete((){
          _chatViewModel.initUser(null, Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor()).whenComplete(() {
            _chatViewModel.setLastMessages(context);
            if(Provider.of<DoctorProvider>(context, listen: false).needAlert()){
              _showMyDialog();
            }
          });
        });
      });
    }


    NotificationService.init().whenComplete((){
      listenNotifications();

      if(isPatient()){
        NotificationService.showBreakfastScheduledNotification(title: 'Hora de desayunar! o.O', body: 'Comencemos este día con un buen desayuno.', time: Time(7, 30, 0));
        NotificationService.showMidDayScheduledNotification(title: 'Hora de merienda! :P', body: '¿Te apetece una merienda de media mañana?', time: Time(11, 30, 0));
        NotificationService.showLunchScheduledNotification(title: 'Hora de almorzar :D!', body: 'Un buen almuerzo es importante.', time: Time(13, 30, 0));
        NotificationService.showMidEveningScheduledNotification(title: 'Hora de merienda! :P', body: 'Una buena comida de media tarde es esencial.', time: Time(17, 0, 0));
        NotificationService.showDinnerScheduledNotification(title: 'Hora de cenar! u.u', body: 'El dia no puede acabar si una buena cena.', time: Time(19, 0, 0));
      }
      else{
        NotificationService.showBreakfastScheduledNotification(title: 'La hora de desayuno ha terminado', body: 'Revise si sus pacientes han marcado su comida.', time: Time(8, 30, 0));
        NotificationService.showMidDayScheduledNotification(title: 'La hora de merienda ha terminado', body: 'Revise si sus pacientes han marcado su comida.', time: Time(12, 30, 0));
        NotificationService.showLunchScheduledNotification(title: 'La hora de almuerzo ha terminado', body: 'Revise si sus pacientes han marcado su comida.', time: Time(14, 30, 0));
        NotificationService.showMidEveningScheduledNotification(title: 'La hora de merienda ha terminado', body: 'Revise si sus pacientes han marcado su comida.', time: Time(18, 0, 0));
        NotificationService.showDinnerScheduledNotification(title: 'La hora de cenar ha terminado', body: 'Revise si sus pacientes han marcado su comida.', time: Time(20, 0, 0));
      }
    });

    super.initState();
  }

  logOut(){
    UserSession().logOut();

    _chatViewModel.client.disconnectUser();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: BottomNavigationBar(
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white70,
          unselectedItemColor: itemSelectedColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home_icon.svg', width: 20,
                color:  currentIndex == 0 ? Colors.white : itemSelectedColor,),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/calendar_icon.svg', width: 20,
                color:  currentIndex == 1 ? Colors.white : itemSelectedColor,),
              label: 'Dieta',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  'assets/chat_icon.svg', width: 20,
                color:  currentIndex == 2 ? Colors.white : itemSelectedColor,),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  'assets/profile_icon.svg', width: 20,
                color:  currentIndex == 3 ? Colors.white : itemSelectedColor,),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return Positioned(
                  top: 50,
                  child: SizedBox(
                    width: size.width,
                    child: IndexedStack(
                      index: currentIndex,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                          child: isPatient() ? HomePage(chatViewModel: _chatViewModel,) : HomePageDoctor(chatViewModel: _chatViewModel,),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: isPatient() ? 20.0 : 5.0),
                          child: isPatient() ? const DietCalendarPage() : const DoctorPatientsList(),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: ChatScreen(chatViewModel: _chatViewModel,),),
                        UserProfileScreen( logOut: () { logOut(); } )
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator(color: primaryColor,));
              }
            },
          )
        ],
      ),
    );
  }
}
