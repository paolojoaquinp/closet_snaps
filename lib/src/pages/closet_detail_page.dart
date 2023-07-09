import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/utils/utils.dart' as utils;
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:flutter/material.dart';


class ClosetDetailPage extends StatelessWidget {
  const ClosetDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ArgumentsClosetModel args = ModalRoute.of(context)?.settings.arguments as ArgumentsClosetModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: ClothesBuild(args.ruta)
    );
  }
}

class ClothesBuild extends StatelessWidget {
  final String ruta;
  const ClothesBuild(this.ruta);

  @override
  Widget build(BuildContext context) {
    return ruta != 'shoes' ? FutureBuilder(
      future: DBProvider.db.getClothesByType(ruta),
      builder: (BuildContext context, AsyncSnapshot<List<ClothesModel>?> snapshot) {
        final data = snapshot.data ?? [];
        return GridView.builder(
          primary: true,
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context,int index) {
            return _clothesCard(data[index]);
          },
          itemCount: data.length,
        );
      },
    ) : FutureBuilder(
      future: DBProvider.db.getShoes(),
      builder: (BuildContext context, AsyncSnapshot<List<Shoes>?> snapshot) {
        final data = snapshot.data ?? [];
        return GridView.builder(
          primary: true,
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context,int index) {
            final el = data[index];
            final color = Color(int.parse(el.color as String, radix: 16) + 0xFF000000);
            final type = el.typeShoes != 'street' ? false : true;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 45,),
              child: MaterialButton(
                onPressed: () {},
                child: ShoesWidget(color: color, isStreet: type,),
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 3,color: Colors.black54),
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
            );
          },
          itemCount: data.length,
        );
      },
    );
  }
}


class _clothesCard extends StatelessWidget {
  final ClothesModel clothes;
  _clothesCard(this.clothes);

  final _clothesWidgets = {
    'shirt': (Color color) => Shirt(color),
    'pants': (Color color) => Pants(color),
    'hoodie': (Color color) => Hoodie(color),
    'shoes': (Color color, bool isStreet) => ShoesWidget(color: color,isStreet: isStreet,),
  };


  @override
  Widget build(BuildContext context) {
    final clothesWidgetBuilder = _clothesWidgets[(clothes.type as String).toLowerCase()];
    if (clothesWidgetBuilder == null) {
      throw ArgumentError('Invalid clothes type: ${clothes.type}');
    }
    final color = utils.parseColorfromString(clothes.color!);
    final clothesWidget = (clothes.type == 'shoes') ? clothesWidgetBuilder(color) : clothesWidgetBuilder(color);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,),
      child: MaterialButton(
        onPressed: () {},
        child: clothesWidget,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 3,color: Colors.black54),
        color: Colors.white,
        borderRadius: BorderRadius.circular(25)
      ),
    );
  }
}