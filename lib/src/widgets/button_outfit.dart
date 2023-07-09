import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/utils/utils.dart' as utils;
import 'package:closet_snaps/src/widgets/bottom_sheet.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';

typedef void HandleOutfits(String kId,OutfitModel newOu, Outfit newLayout);

class BotonTabla extends StatefulWidget {
  final String keyId;
  final OutfitModel? outfit;
  final HandleOutfits updateOutfit;
  final Outfit? outfitLayout;
  final DateTime? date;
  final bool? isNull;
  const BotonTabla({
     required this.keyId,
     required this.outfit,
     required this.updateOutfit,
     required this.outfitLayout,
     this.date,
     this.isNull
  });

  @override
  State<BotonTabla> createState() => BotonTablaState();
}

class BotonTablaState extends State<BotonTabla> {
  bool closetSelected = false;
  Outfit? outfitLayout;
  OutfitModel? outfitModel;
  void createNewOutfit() {
    // Acción al presionar "Crea un nuevo outfit"
  }

  void selectFromCloset() {
    setState(() {
      closetSelected = true;
    });
  }

  void goBack() {
    setState(() {
      closetSelected = false;
    });
  }

  void saveOutfit(Outfit value,OutfitModel value1) {
    // Acción al presionar "Guardar"
    outfitLayout = value;
    outfitModel = value1;
  }
  @override
  Widget build(BuildContext context) {
    final args = ArgumentsCreateOutfit(
      widget.keyId,
      widget.outfit as OutfitModel,
      widget.updateOutfit,
      widget.outfitLayout as Outfit,
      widget.date
    );
    outfitLayout = widget.outfitLayout;
    return Container(
      height: 180.0,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0,5.0)
          )
        ]
      ),
      child: MaterialButton(
        onPressed: (widget.isNull != null && widget.isNull == true) ? null : (){
          Navigator.pushNamed(context, 'pick-outfit-page', arguments: args);
          /* getModal(context,args);  */
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 5,),
                child: outfitLayout
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                utils.obtenerDateFormated(widget.date as DateTime),
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }


  void getModal(BuildContext context, ArgumentsCreateOutfit args) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MyBottomSheet(args);
      },
    );
  }
}
