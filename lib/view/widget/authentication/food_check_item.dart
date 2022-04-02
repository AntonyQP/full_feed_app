import 'package:flutter/material.dart';
import 'package:full_feed_app/model/entities/preference.dart';
import 'package:full_feed_app/providers/user_provider.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/dtos/preference_register_dto.dart';


class FoodItem extends StatefulWidget {

  final String imagePath;
  final Preference preference;
  final String type;
  final Color color;
  const FoodItem({Key? key, required this.imagePath, required this.preference, required this.type,
    required this.color}) : super(key: key);

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool selected = false;
  
  String prepareString(String originalText){
    return originalText.substring(0, 1) + originalText.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.white,
      onTap: (){
        if(selected) {
            if(widget.type == "FAVORITE"){
              Provider.of<RegisterViewModel>(context, listen: false).preferencesFavorite.add(PreferenceRegisterDto(widget.preference.preferencesId!, widget.type));
            }
            else{
              Provider.of<RegisterViewModel>(context, listen: false).preferencesAllergy.add(PreferenceRegisterDto(widget.preference.preferencesId!, widget.type));
            }
          }
          else{
            if(widget.type == "FAVORITE"){
              Provider.of<RegisterViewModel>(context, listen: false).preferencesFavorite.removeWhere((element) => element.preferenceId == widget.preference.preferencesId);
            }
            else{
              Provider.of<RegisterViewModel>(context, listen: false).preferencesAllergy.removeWhere((element) => element.preferenceId == widget.preference.preferencesId);
            }
        }
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: selected ? fooSelectedColor : widget.color,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(prepareString(widget.preference.name.toString()), style: TextStyle(fontSize: 10),),
                ),
                Image.asset(widget.imagePath, fit: BoxFit.contain, width: 45, height: 45),
              ],
            ),
          )
      ),
    );
  }
}
