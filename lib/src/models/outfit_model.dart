// To parse this JSON data, do
//
//     final outfitModel = outfitModelFromJson(jsonString);

import 'dart:convert';

OutfitModel outfitModelFromJson(String str) => OutfitModel.fromJson(json.decode(str));

String outfitModelToJson(OutfitModel data) => json.encode(data.toJson());

class ScheduleModel {
    ScheduleModel({
        this.id,
        this.firstOu,
        this.secondOu,
        this.thirdOu,
        this.fourthOu,
        this.fifthOu,
        this.sixthOu,
        this.seventhOu,
        this.initDate,
        this.endingDate,
    });

    String? id;
    String? firstOu;
    String? secondOu;
    String? thirdOu;
    String? fourthOu;
    String? fifthOu;
    String? sixthOu;
    String? seventhOu;
    int?    initDate;
    int?    endingDate;

    factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id : json["id"],
        firstOu : json["first_ou"],
        secondOu : json["second_ou"],
        thirdOu : json["third_ou"],
        fourthOu : json["fourth_ou"],
        fifthOu : json["fifth_ou"],
        sixthOu : json["sixth_ou"],
        seventhOu : json["seventh_ou"],
        initDate : json["initDate"],
        endingDate : json["endingDate"],
    );

    Map<String, dynamic> toJson() => {
        "id" : id,
        "first_ou" : firstOu,
        "second_ou" : secondOu,
        "third_ou" : thirdOu,
        "fourth_ou" : fourthOu,
        "fifth_ou" : fifthOu,
        "sixth_ou" : sixthOu,
        "seventh_ou" : seventhOu,
        "initDate" : initDate,
        "endingDate" : endingDate,
    };
}
class OutfitModel {
    OutfitModel({
        this.id,
        this.upper,
        this.lower,
        this.shoes,
        this.isStreetShoes,
        this.createdAt
    });

    String? id;
    String? upper;
    String? lower;
    String? shoes;
    bool? isStreetShoes;
    int? createdAt;

    factory OutfitModel.fromJson(Map<String, dynamic> json) => OutfitModel(
        id : json["id"],
        upper: json["idClothUpper"],
        lower: json["idClothLower"],
        shoes: json["idShoes"],
        createdAt: json["createdAt"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idClothUpper": upper,
        "idClothLower": lower,
        "idShoes": shoes,
        "createdAt": createdAt
    };
}

class ClothesModel {
    ClothesModel({
        this.id,
        this.type,
        this.color,
        this.createdAt,
    });

    String? id;
    String? type;
    String? color;
    int? createdAt;

    factory ClothesModel.fromJson(Map<String, dynamic> json) => ClothesModel(
        id: json["id"],
        type: json["type"],
        color: json["color"],
        createdAt: json["createdAt"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "color": color,
        "createdAt": createdAt
    };
}

class Shoes {
    Shoes({
        this.id,
        this.typeShoes,
        this.color,
        this.createdAt
    });

    String? id;
    String? typeShoes;
    String? color;
    int? createdAt;

    factory Shoes.fromJson(Map<String, dynamic> json) => Shoes(
        id: json["id"],
        typeShoes: json["typeShoes"],
        color: json["color"],
        createdAt: json["createAt"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "typeShoes": typeShoes,
        "color": color,
        "createdAt": createdAt
    };
}
