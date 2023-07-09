import 'dart:io';

import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/utils/utils.dart';
import 'package:closet_snaps/src/widgets/clothes.dart';

import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DBProvider {

  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    final path = p.join(documentsDirectory, 'OutfitsDB.db');
  
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Outfits ( '
          ' id TEXT,'
          ' idClothUpper TEXT,'
          ' idClothLower TEXT,'
          ' idShoes TEXT,'
          ' createdAt INT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Clothes ( '
          ' id TEXT,'
          ' type TEXT,'
          ' color TEXT,'
          ' createdAt INT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Shoes ( '
          ' id TEXT,'
          ' typeShoes TEXT,'
          ' color TEXT,'
          ' createdAt INT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Schedule ( '
          ' id TEXT,'
          ' first_ou TEXT,'
          ' second_ou TEXT,'
          ' third_ou TEXT,'
          ' fourth_ou TEXT,'
          ' fifth_ou TEXT,'
          ' sixth_ou TEXT,'
          ' seventh_ou TEXT,'
          ' initDate INT,'
          ' endingDate INT'
          ')'
        );
      }
    );
  }
  
  nuevoSchedule(ScheduleModel schedule) async {
    final db = await database;
    final res = await db?.insert('Schedule', schedule.toJson());
    return res;
  }
  
  nuevoOutfit(OutfitModel outfit) async {
    final db = await database;
    final res = await db?.insert('Outfits', outfit.toJson());
    return res;
  }

  nuevoClothes(ClothesModel clothes) async {
    final db = await database;
    final res = await db?.insert('Clothes', clothes.toJson());
    return res;
  }
  nuevoShoes(Shoes shoes) async {
    final db = await database;
    final res = await db?.insert('Shoes', shoes.toJson());
    return res;
  }

  Future<int> actualizarSchedulePorId(String id, String keyId, String nuevoValor) async {
    final db = await database;
    final res = await db?.update(
      'Schedule',
      {keyId: nuevoValor},
      where: 'id = ?',
      whereArgs: [id],
    );
    return res ?? 0;
  }

  Future<int> actualizarOutfitPorId(String id, OutfitModel nuevoOutfit) async {
    final db = await database;
    final updatedRow = nuevoOutfit.toJson();
    updatedRow.remove('id');
    final res = await db?.update(
      'Outfits',
      updatedRow,
      where: 'id = ?',
      whereArgs: [id],
    );
    return res ?? 0;
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'OutfitsDB.db');
    databaseFactory.deleteDatabase(path);
  }

  Future<List<ScheduleModel>?> getTodosSchedules() async {
    try {
      final db = await database;
      final res = await db?.query('Schedule',orderBy: 'initDate DESC');
      return res!.isNotEmpty ? res.map((c) => ScheduleModel.fromJson(c)).toList() : [];
    } catch(e) {
      return null;
    }
  }

  Future<ScheduleModel?> getScheduleById(String idSchedule) async {
    final db = await database;
    final res = await db?.query('Schedule', where: 'id = ?', whereArgs: [idSchedule]);
    if (res != null && res.isNotEmpty) {
      return ScheduleModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<List<OutfitModel>?> getTodosOutfits() async {
    try {
      final db = await database;
      final res = await db?.query('Outfits',orderBy: 'createdAt DESC');
      return res!.isNotEmpty ? res.map((c) => OutfitModel.fromJson(c)).toList() : [];
    } catch(e) {
      return null;
    }
  }

  Future<OutfitModel?> getOutfitById(String id) async {
    final db = await database;
    final res = await db?.query('Outfits', where: 'id = ?', whereArgs: [id]);
    if (res != null && res.isNotEmpty) {
      return OutfitModel.fromJson(res.first);
    } else {
      return null;
    }
  }


  //Eliminar registros
  Future<int?> deleteOutfit(String id) async {
    final db = await database;
    final res = await db?.delete('Outfits',where: 'id=?',whereArgs: [id]);
    return res;
  }
  Future<int?> deleteSchedule(String idSchedule) async {
    final db = await database;
    final schedule = await getScheduleById(idSchedule);
    final res = await db?.delete('Schedule',where: 'id=?',whereArgs: [idSchedule]);
    await deleteOutfit(schedule!.firstOu as String);
    await deleteOutfit(schedule.secondOu as String);
    await deleteOutfit(schedule.thirdOu as String);
    await deleteOutfit(schedule.fourthOu as String);
    await deleteOutfit(schedule.fifthOu as String);
    await deleteOutfit(schedule.sixthOu as String);
    await deleteOutfit(schedule.seventhOu as String);
    return res;
  }

  Future<List<ClothesModel>> getClothesById(String idClothes) async {
    final db  = await database;
    final res = await db?.query('Clothes', where: 'id = ?', whereArgs: [idClothes]) as List<Map<String, Object?>>;
    return res.isNotEmpty ? res.map((e) => ClothesModel.fromJson(e)).toList() : [];
  }
  Future<List<ClothesModel>?> getClothesByType(String type) async {
    try {
      final db  = await database;
      final res = await db?.query('Clothes', where: 'type = ?', whereArgs: [type]) as List<Map<String, Object?>>;
      return res.isNotEmpty ? res.map((e) => ClothesModel.fromJson(e)).toList() : [];
    } catch(e) {
      /* print(e); */
      return null;
    }
  }

  // Shoes DB

  Future<List<Shoes>?> getShoes() async {
    try {
      final db = await database;
      final res = await db?.query('Shoes');
      return res!.isNotEmpty ? res.map((c) => Shoes.fromJson(c)).toList() : [];
    } catch(e) {
      return null;
    }
  }


 /*  Future<dynamic> alterTable(String TableName, String ColumneName) async {
    var dbClient = await database;
    var count = await dbClient?.execute("ALTER TABLE $TableName ADD "
        "COLUMN $ColumneName INT;");
    print(await dbClient?.query('Tests'));
    return count;
  } 
 */
  Future<Map<String, dynamic>?> getOutfitDetails(String id) async {
    final outfit = await getOutfitById(id);
    if (outfit != null) {
      final upper = await getClothesDetails(outfit.upper);
      final lower = await getClothesDetails(outfit.lower);
      final shoes = await getShoesDetails(outfit.shoes);
      
      return {
        'upperType': upper?.type,
        'upperColor': upper?.color,
        'lowerType': lower?.type,
        'lowerColor': lower?.color,
        'shoesColor': shoes?.color,
        'typeShoes': shoes?.typeShoes
      };
    } else {
      return null;
    }
  }

  Future<ClothesModel?> getClothesDetails(String? clothesId) async {
    if (clothesId == null) {
      return null;
    }
    
    final db = await database;
    final res = await db?.query('Clothes', where: 'id = ?', whereArgs: [clothesId]);
    if (res != null && res.isNotEmpty) {
      return ClothesModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<Shoes?> getShoesDetails(String? shoesId) async {
    if (shoesId == null) {
      return null;
    }
    
    final db = await database;
    final res = await db?.query('Shoes', where: 'id = ?', whereArgs: [shoesId]);
    if (res != null && res.isNotEmpty) {
      return Shoes.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<ScheduleModel?> obtenerUltimoScheduleActivo() async {
    try{
      final fechaActual = DateTime.now();
      List<ScheduleModel>? schedules = await getTodosSchedules();
      if(schedules != null) {
        ScheduleModel first = schedules.first;
        final fechaInicio = DateTime.fromMillisecondsSinceEpoch(first.initDate ?? 0);
        final fechaFinal = DateTime.fromMillisecondsSinceEpoch(first.endingDate ?? 0);
        if (fechaInicio.isBefore(fechaActual) && fechaFinal.isAfter(fechaActual)) {
          return first;
        }
      }
      return null;
    } catch(e) {
      return null;
    }
  }

  Future<List<ScheduleModel>?> obetenerHistorial() async {
    try {
      final activeElem = await obtenerUltimoScheduleActivo();
      final schedules = await getTodosSchedules();
      if(activeElem != null && schedules != null) {
        schedules.removeLast();
      }
      return schedules;
    } catch(e) {
      return await getTodosSchedules();
    }
  }

  Future<Map<String,dynamic>?> obtenerOutfitsFromSchedule(String idSchedule) async {
    try {
      final schedule = await getScheduleById(idSchedule);
      if(schedule!= null) {

        final detailsfirst = await getOutfitDetails(schedule.firstOu as String);
        final detailsSecond = await getOutfitDetails(schedule.secondOu as String);
        final detailsThird = await getOutfitDetails(schedule.thirdOu as String);
        final detailsFourth = await getOutfitDetails(schedule.fourthOu as String);
        final detailsFifth = await getOutfitDetails(schedule.fifthOu as String);
        final detailsSixth = await getOutfitDetails(schedule.sixthOu as String);
        final detailsSeventh = await getOutfitDetails(schedule.seventhOu as String);
        final arrModels = {
          "first_ou"  : detailsfirst,
          "second_ou" : detailsSecond,
          "third_ou"  : detailsThird,
          "fourth_ou" : detailsFourth,
          "fifth_ou"  : detailsFifth,
          "sixth_ou"  : detailsSixth,
          "seventh_ou": detailsSeventh,
        };
        
        final arrWidgets = arrModels.map<String,Outfit>((key, value) {
          final upper =  widgetBuilderFunc(value);
          final lower = Pants(parseColorfromString(value!['lowerColor']));
          return MapEntry(key,Outfit(
            upperClothes: upper,
            lowerClothes: lower,
            shoes: parseColorfromString(value['shoesColor']),
            streetShoes: value['typeShoes'] == 'street' ? true :false,
          ));
        });
        return {
          'widgets':arrWidgets,
          'initDate': schedule.initDate
        };
      }
      return null;
    } catch(e) {
      return null;
    }
  }

  Future<Map<String,dynamic>?> obtenerOutfitDay() async {
    try {
      final lastSchedule = await obtenerUltimoScheduleActivo();
      if(lastSchedule != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(lastSchedule.initDate as int);
        final today = DateTime.now();
        final rta = await obtenerOutfitsFromSchedule(lastSchedule.id as String);
        final outfits = rta!['widgets'];
        final widgets = {
          0: "first_ou",
          1: "second_ou",
          2: "third_ou",
          3: "fourth_ou",
          4: "fifth_ou",
          5: "sixth_ou",
          6: "seventh_ou",
        };
        Outfit? response;
        String? keyId;
        OutfitModel? model;
        widgets.forEach((key, value) {
          final aux = date.add(Duration(days: key));
          if(aux.day==today.day) {
            response = outfits[value];
            keyId = value;
          }
        });
        return {
          'outfit':response,
          'key_id':keyId,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Widget widgetBuilderFunc(value) {
    if(value['upperType'] == 'shirt') {
      return Shirt(parseColorfromString(value['upperColor']));
    }
    if(value['upperType'] == 'hoodie'){
      return Hoodie(parseColorfromString(value['upperColor']));
    }
    return Container();
  }
}