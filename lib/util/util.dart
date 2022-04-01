


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