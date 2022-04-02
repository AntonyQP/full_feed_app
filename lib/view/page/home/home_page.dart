

import 'package:flutter/material.dart';
import 'package:full_feed_app/view_model/chat_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/user_session.dart';
import '../../../util/colors.dart';
import '../../widget/diet_schedule/day_plate.dart';
import '../../widget/home/home_achievements_card.dart';
import '../../widget/home/home_diet_card.dart';
import '../../widget/home/home_nutritionist_card.dart';


class HomePage extends StatefulWidget {
  final ChatViewModel chatViewModel;
  const HomePage({Key? key, required this.chatViewModel}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<bool> _future;

  @override
  void initState() {
    _future = Provider.of<LoggedInViewModel>(context, listen: false).setHomeDietDayMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text.rich(TextSpan(
                children: [
                  const TextSpan(text: 'Bienvenido de nuevo, ', style: TextStyle(fontSize: 16)),
                  TextSpan(text: UserSession().userFirstName.contains(" ")? UserSession().userFirstName.substring(0, UserSession().userFirstName.lastIndexOf(" ")) : UserSession().userFirstName
                  , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ])
            ),
          ),
          const SizedBox(height: 25.0),
          HomeDietCard(
            child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.data == true){
                      if(Provider.of<LoggedInViewModel>(context, listen: false).getDayMeals().isNotEmpty){
                        return Wrap(
                            children: List.generate(5, (index) =>
                                DayPlate(meal: Provider.of<LoggedInViewModel>(context, listen: false).getDayMeals()[index], selected: false,))
                        );
                      }
                      else{
                        return SizedBox(
                          height: 250,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('No tiene dietas hoy', style: TextStyle(color: Colors.grey)),
                                Text('Disfrute de su dia con moderacion', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    else{
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No tiene dietas hoy', style: TextStyle(color: Colors.grey)),
                              Text('Disfrute de su dia con moderacion', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox( width: 15, height: 15, child:  CircularProgressIndicator( color: primaryColor,));
                }),
          ),
          const SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeNutritionistCard(chatViewModel: widget.chatViewModel),
              const HomeAchievementsCard()
            ],
          )
        ],
      ),
    );
  }
}


