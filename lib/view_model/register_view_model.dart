
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/preferences_service.dart';
import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../model/dtos/doctor_register_dto.dart';
import '../model/dtos/patient_register_dto.dart';
import '../model/dtos/preference_register_dto.dart';
import '../model/entities/doctor.dart';
import '../model/entities/preference.dart';
import '../model/entities/region.dart';

class RegisterViewModel extends ChangeNotifier{

  String _desireRol = "";

  final PreferenceService _preferenceService = PreferenceService();
  final UserService _userService = UserService();

  final List<Preference> _meats = [];
  final List<Preference> _vegetables = [];
  final List<Preference> _seafood = [];
  final List<Preference> _tubers = [];
  final List<Preference> _fruits = [];
  List<PreferenceRegisterDto> preferencesFavorite = [];
  List<PreferenceRegisterDto> preferencesAllergy = [];
  List<Region> regionList = [];
  late double _height, _weight, _imc;
  late int _regionId, _doctorId;
  late String _accessCode;

  bool _loggedIn = false;

  final Map<dynamic, dynamic> _patientRegisterDto = PatientRegisterDto("", "", "", "", "", "", "", "", "", "", 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).toJson();
  final Map<dynamic, dynamic> _doctorRegisterDto = DoctorRegisterDto("", "", "", "", "", "", "", "", "", "", "").toJson();


  List<Preference> getListPreferenceOf(String value){
    switch(value){
      case "meat":
        return _meats;
      case "vegetable":
        return _vegetables;
      case "seaFood":
        return _seafood;
      case "tuber":
        return _tubers;
      case "fruit":
        return _fruits;
      default:
        return [];
    }
  }

  String getDesireRol(){
    return _desireRol;
  }

  setDesireRol(String rol){
    _desireRol = rol;
    notifyListeners();
  }

  setAccessCode(String newAccessCode){
    _accessCode = newAccessCode;
  }

  bool getLoggedIn(){
    return _loggedIn;
  }

  setLoggedIn(bool newState){
    _loggedIn = newState;
  }


  //Data control

  setUserRegisterDto(String value, dynamic newValue){
    if(_desireRol == "p"){
      _patientRegisterDto[value] = newValue;
    }
    else{
      _doctorRegisterDto[value] = newValue;
    }
  }

  setDoctorRegisterDto(String value, String newValue){
    _doctorRegisterDto[value] = newValue;
  }

  setSex(String _sex){
    switch(_sex){
      case "Masculino":
        setUserRegisterDto('sex', 'h');
        break;
      case "Femenino":
        setUserRegisterDto('sex', 'm');
        break;
    }
  }

  setWeight(double weight){
    _weight = weight;
  }

  setHeight(double height){
    _height = height;
  }

  calculateImc(){
    _imc = _weight/pow(_height, 2);
    setUserRegisterDto('imc', _imc);
  }

  double getImc(){
    return _imc;
  }

  //Location

  determinateRegion(String addressRegion){
    String regionToValidate = addressRegion.substring(addressRegion.lastIndexOf(" ") + 1);
    regionToValidate = regionToValidate.toUpperCase();

    for(int i = 0; i < regionList.length; i ++){
      if(regionList[i].name == regionToValidate){
        _regionId = regionList[i].regionId!;
        setUserRegisterDto('regionId', _regionId);
        break;
      }
    }
  }

  determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position currentPosition;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentPosition = await Geolocator.getCurrentPosition();

    getAddressFromLatLng(currentPosition);

  }

  getAddressFromLatLng(Position _currentPosition) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      determinateRegion(place.administrativeArea!);

    } catch (e) {
      print(e);
    }
  }

  //List Preferences

  setPreferencesLists(){
    _preferenceService.listAllPreferences().then((preferenceList){
      categorizeLists(preferenceList);
    });
  }

  categorizeLists(List<Preference> preferenceList){
    for(int i = 0; i < preferenceList.length; i++){
      if(preferenceList[i].category!.categoryId == 4){
        _meats.add(preferenceList[i]);
        continue;
      }
      if(preferenceList[i].category!.categoryId == 14){
        _vegetables.add(preferenceList[i]);
        continue;
      }
      if(preferenceList[i].category!.categoryId == 24){
        _seafood.add(preferenceList[i]);
        continue;
      }
      if(preferenceList[i].category!.categoryId == 34){
        _tubers.add(preferenceList[i]);
        continue;
      }
      if(preferenceList[i].category!.categoryId == 44){
        _fruits.add(preferenceList[i]);
        continue;
      }
    }
  }

  //Nutrition Plan

  Future<bool> validateAccessCode() async{
    return await _userService.validateAccessCode(_accessCode);
  }

  Future<List<Doctor>> getDoctors() async{
    return await _userService.getDoctors();
  }

  Future<bool> registerAndLogin() async{
    return await _userService.registerAndLogin(_patientRegisterDto);
  }

}