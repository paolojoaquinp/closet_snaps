import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';

class ArgumentsClosetModel {
  final String ruta;
  final String title;

  ArgumentsClosetModel(this.ruta,this.title);
}

typedef void handleOutfits(String kId,OutfitModel outfit, Outfit newLayout);

class ArgumentsCreateOutfit {
  final String keyId;
  final OutfitModel outfit;
  final handleOutfits updateOutfit;
  final Outfit layout;
  final DateTime? date;

  ArgumentsCreateOutfit(this.keyId,this.outfit,this.updateOutfit,this.layout,this.date);
}


class ArgumentsGenerateOutfit {
  final ScheduleModel? schedule;
  final String? titlePage;
  ArgumentsGenerateOutfit(this.schedule, this.titlePage);
}



class ArgumentsEditOutfit {
  final ScheduleModel? schedule;
  final String? titlePage;
  ArgumentsEditOutfit(this.schedule, this.titlePage);
}