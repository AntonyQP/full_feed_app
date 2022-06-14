


import 'dart:ui';

import 'package:full_feed_app/util/colors.dart';

import '../model/entities/user_session.dart';

bool isPatient(){
  if(UserSession().rol == 'p'){
    return true;
  }
  else{
    return false;
  }
}

String getMonth(String date){
  DateTime aux = DateTime.parse(date);
  String day = "";
  switch(aux.month){
    case 1:
      day = "Ene";
      break;
    case 2:
      day = "Feb";
      break;
    case 3:
      day = "Mar";
      break;
    case 4:
      day = "Abr";
      break;
    case 5:
      day = "May";
      break;
    case 6:
      day = "Jun";
      break;
    case 7:
      day = "Jul";
      break;
    case 8:
      day = "Ago";
      break;
    case 9:
      day = "Set";
      break;
    case 10:
      day = "Oct";
      break;
    case 11:
      day = "Nov";
      break;
    case 12:
      day = "Dic";
      break;
  }
  return day;
}

String getDay(String date){
  DateTime aux = DateTime.parse(date);
  String day = "";
  switch(aux.weekday){
    case 1:
      day = "Lun";
      break;
    case 2:
      day = "Mar";
      break;
    case 3:
      day = "Mie";
      break;
    case 4:
      day = "Jue";
      break;
    case 5:
      day = "Vie";
      break;
    case 6:
      day = "Sab";
      break;
    case 7:
      day = "Dom";
      break;
  }
  return day;
}

String setDayByDayIndex(int day){
  String dayName = "";
  switch(day){
    case 1:
      dayName = "Lun";
      break;
    case 2:
      dayName = "Mar";
      break;
    case 3:
      dayName = "Mie";
      break;
    case 4:
      dayName = "Jue";
      break;
    case 5:
      dayName = "Vie";
      break;
    case 6:
      dayName = "Sab";
      break;
    case 7:
      dayName = "Dom";
      break;
  }
  return dayName;
}

String setFoodDayName(String originalName){
  switch(originalName){
    case "DESAYUNO":
      return "Desayuno";
    case "ALMUERZO":
      return "Almuerzo";
    case "CENA":
      return "Cena";
    case "MERIENDA_DIA":
      return "Merienda Dia";
    case "MERIENDA_TARDE":
      return "Merienda Tarde";
    default:
      return "";
  }
}

String setScheduleName(String originalName){
  switch(originalName){
    case "DESAYUNO":
      return "desayuno";
    case "ALMUERZO":
      return "almuerzo";
    case "CENA":
      return "cena";
    case "MERIENDA_DIA":
      return "merienda de dia";
    case "MERIENDA_TARDE":
      return "merienda de tarde";
    default:
      return "";
  }
}


int getCurrentWeek(){
  String date = DateTime.now().toString();
  String firstDay = date.substring(0, 8) + '01' + date.substring(10);
  int weekDay = DateTime.parse(firstDay).weekday;
  DateTime testDate = DateTime.now();
  int weekOfMonth;
  weekDay--;
  weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
  weekDay++;
  if (weekDay == 7) {
    weekDay = 0;
  }
  weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
  return weekOfMonth;
}

String getCurrentDay(String time) {
  if (time == 'Monday')
    return 'Lunes';
  else if (time == 'Tuesday')
    return 'Martes';
  else if (time == 'Wednesday')
    return 'Miércoles';
  else if (time == 'Thursday')
    return 'Jueves';
  else if (time == 'Friday')
    return 'Viernes';
  else if (time == 'Saturday')
    return 'Sábado';
  else if (time == 'Sunday')
    return 'Domingo';
  else return ' ';
}

String setPatientStateName(double imc){
  if (imc >= 40.0) {
    return "OBESIDAD III";
  }
  if (imc < 39.9 && imc >= 35.0) {
    return "OBESIDAD II";
  }
  if (imc < 34.9 && imc >= 30.0) {
    return "OBESIDAD I";
  }
  if (imc < 30.0 && imc >= 25.0) {
    return "SOBREPESO";
  }
  if (imc < 24.9 && imc >= 18.5) {
    return "NORMAL";
  }
  if (imc < 18.5) {
    return "BAJO PESO";
  }
  return "NORMAL";
}

Color setPatientStateColor(double imc){
  if (imc >= 40.0) {
    return fatIIIWeightColor;
  }
  if (imc < 39.9 && imc >= 35.0) {
    return fatIIWeightColor;
  }
  if (imc < 34.9 && imc >= 30.0) {
    return fatIWeightColor;
  }
  if (imc < 30.0 && imc >= 25.0) {
    return Color(0XFFFF295D);
  }
  if (imc < 30.0 && imc >= 25.0) {
    return Color(0XFFFF295D);
  }
  if (imc < 24.9 && imc >= 18.5) {
    return Color(0XFF02D871);
  }
  if (imc < 18.5) {
    return Color(0XFFFFEA29);
  }

  return Color(0XFFFFEA29);
}