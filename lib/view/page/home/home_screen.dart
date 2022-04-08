import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/util/strings.dart';
import 'package:full_feed_app/util/util.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:full_feed_app/view_model/illness_list_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../model/entities/user_session.dart';
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

  @override
  void initState() {
    _chatViewModel = ChatViewModel(context);

    if (isPatient()) {
      _future = Provider.of<LoggedInViewModel>(context, listen: false).setDoctorByPatient().whenComplete(() {
        Provider.of<ProfileViewModel>(context, listen: false).initPatientData().whenComplete(() {
          _chatViewModel.initUser(Provider.of<LoggedInViewModel>(context, listen: false).getDoctorByPatient().user!.dni, []).whenComplete((){
            Provider.of<IllnessListViewModel>(context, listen: false).populateIllnessesByPatient();
          });
        });
      });
    }
    else{
      _future = Provider.of<LoggedInViewModel>(context, listen: false).setPatientsByDoctor().whenComplete((){
        _chatViewModel.initUser(null,
            Provider.of<LoggedInViewModel>(context, listen: false).getPatientsByDoctor());
      });
    }
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
                          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                          child: isPatient() ? HomePage(chatViewModel: _chatViewModel,) : HomePageDoctor(chatViewModel: _chatViewModel,),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: isPatient() ? 20.0 : 5.0),
                          child: isPatient() ? const DietCalendarPage() : const DoctorPatientsList(),),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
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
