import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomSheet extends StatefulWidget {
  final ArgumentsCreateOutfit args;
  MyBottomSheet(this.args);
  
  @override
   State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool closetSelected = false;
  Outfit? outfitState;
  void selectFromCloset() {
    setState(() {
      closetSelected = true;
    });
  }
  void saveOutfit(int index, List<OutfitModel> list,Outfit outfit) {
    final arguments = widget.args;
    // Acción al presionar "Guardar"
    arguments.updateOutfit(
      arguments.keyId,
      list[index],
      outfit
    );
  }

  @override
  Widget build(BuildContext context) {
    final outfitProvider = Provider.of<UserPreferencesModel>(context, listen: false);
    
    outfitProvider.loadOutfits();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 2,child: Container()),
              const Expanded(
                flex: 8,
                child: Text(
                  'Selecciona una opción',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.close)
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          if (!closetSelected)
            Column(
              children: [
                ElevatedButton(
                  child: const Text('Crea un nuevo outfit'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'pick-outfit-page', arguments: widget.args);
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Seleccionar uno de mi closet'),
                  onPressed: () {
                    selectFromCloset();
                  },
                ),
              ],
            ),
          if (closetSelected)
            Column(
              children: [
                Consumer<UserPreferencesModel>(
                  builder: (context, outfitProvider, _) {
                    if (outfitProvider.outfits.isEmpty) {
                      return const Text('No hay outfits disponibles',style: TextStyle(color: Colors.black),);
                    }
                    final outfit = outfitProvider.outfits[outfitProvider.currentIndex];
                    return FutureBuilder(
                      future: DBProvider.db.getOutfitDetails(outfit.id as String),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          final details = snapshot.data!;
                          final upperClothes = details['upperType'];
                          final lowerClothes = details['lowerType'];
                          final shoes = details['shoesColor'];

                          outfitState = Outfit(
                                upperClothes: upperClothes,
                                lowerClothes: lowerClothes,
                                shoes: shoes,
                          );
                          return Column(
                            children: [
                              outfitState ?? Container(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: outfitProvider.previousOutfit,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: outfitProvider.nextOutfit,
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ),

              ],
            ),
          SizedBox(height: 8),
          if (closetSelected)
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () => saveOutfit(
                outfitProvider.outfitsIndex,
                outfitProvider.outfits,
                outfitState as Outfit
              ),
            ),
        ],
      ),
    );
  }
}