import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:flutter/material.dart';

class UserPreferencesModel with ChangeNotifier {
  int _currentIndex = 0;
  Color _shirt = Colors.red;
  Color _pants = Colors.red;
  Color _shoes = Colors.red;
  bool _streetShoes = false;
  ScheduleModel _scheduleActive = ScheduleModel();
  List<OutfitModel> _outfits = [];
  int _outfitsIndex = 0;
  void Function(int? newTab)? _changeTab;


  void Function(int? value)? get changeTab => this._changeTab;

  set changeTab(void Function(int? value)? a) {
    this._changeTab = a;
  }



  ScheduleModel get scheduleActive => this._scheduleActive;

  set scheduleActive(ScheduleModel value) {
    this._scheduleActive = value;
    notifyListeners();
  }

  int get currentIndex => this._currentIndex;

  set currentIndex(int value) {
    this._currentIndex = value;
    notifyListeners();
  }
  Color get shirt => this._shirt;

  set shirt(Color value) {
    this._shirt = value;
    
  }
  Color get pants => this._pants;

  set pants(Color value) {
    this._pants = value;
    
  }
  Color get shoes => this._shoes;

  set shoes(Color value) {
    this._shoes = value;
    
  }
  bool get streetShoes => this._streetShoes;

  set streetShoes(bool value) {
    this._streetShoes = value;
    
  }

  List<OutfitModel> get outfits => this._outfits;

  set outfits(List<OutfitModel> value) {
    this._outfits = value;
    notifyListeners();
  }

  int get outfitsIndex => this._outfitsIndex;

  set outfitsIndex(int value){
    this._outfitsIndex = value;
    notifyListeners();
  }

  Future<void> loadOutfits() async {
    final rta =  await DBProvider.db.getTodosOutfits();
    if(rta != null) {
      _outfits = rta;
    }
    notifyListeners();
  }

  void previousOutfit() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  void nextOutfit() {
    if (currentIndex < _outfits.length - 1) {
      currentIndex++;
      notifyListeners();
    }
  }

}