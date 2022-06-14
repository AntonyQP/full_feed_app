
class DoctorNotificationService{



  String validateMealAtHour(DateTime _actualDateTime){
    if(_actualDateTime.hour > 20){
      return 'CENA';
    }
    if(_actualDateTime.hour > 18){
      return 'MERIENDA_TARDE';

    }
    if(_actualDateTime.hour > 15){
      return 'ALMUERZO';
    }
    if(_actualDateTime.hour > 12){
      return 'MERIENDA_DIA';
    }
    if(_actualDateTime.hour > 9){
      return 'DESAYUNO';
    }
    return '';
  }

}