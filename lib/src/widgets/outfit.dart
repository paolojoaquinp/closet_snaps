import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:closet_snaps/src/user_preferences/user_preferences.dart';
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Outfit extends StatelessWidget {
  Widget upperClothes = Shirt(Colors.black);
  Widget lowerClothes = Pants(Colors.black);
  final Color shoes;
  final bool streetShoes;
  Outfit({
    required this.upperClothes,
    required this.lowerClothes,
    this.shoes: Colors.red,
    this.streetShoes: true
  });

  @override
  Widget build(BuildContext context) {
    final outfitModel = Provider.of<UserPreferencesModel>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Builder(
      builder: (BuildContext context) {
        /* outfitModel.shirt = shirt; */
        /* outfitModel.pants = pants; */
        outfitModel.shoes = shoes;
        outfitModel.streetShoes = streetShoes;
        return Column(
          children: [
            Expanded(
              flex: 10,
              child: upperClothes,
            ),
            /* SizedBox(child: Container(),height: 4,), */
            Expanded(
              flex: 9,
              child: lowerClothes ,
            ),
            Expanded(
              flex: 2,
              child: ShoesWidget(color: outfitModel.shoes, isStreet: outfitModel.streetShoes),
            )
          ],
        );
      }
    );
  }
}
