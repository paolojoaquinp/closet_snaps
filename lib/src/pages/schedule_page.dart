import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:closet_snaps/src/widgets/custom_header.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomHeader(title:'Mi planeacion Semanal',),
          Expanded(
            child: SingleChildScrollView(child: _botonesTabla()),
          )
        ],
      )
    );
  }
  Widget _botonesTabla() {
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            _BotonTabla(),
            _BotonTabla(),
            _BotonTabla(),
          ]
        ),
        TableRow(
          children: <Widget>[
            _BotonTabla(),
            _BotonTabla(),
            _BotonTabla(),
          ]
        ),
        TableRow(
          children: <Widget>[
            Spacer(),
            _BotonTabla(),
            Spacer(),
          ]
        ),
      ],
    );
  }
}

class _BotonTabla extends StatelessWidget {
  const _BotonTabla({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      margin: EdgeInsets.all(15.0),
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
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Outfit(
                upperClothes: Shirt(Colors.black),
                lowerClothes: Pants(Colors.black),
                shoes: Colors.black,
                streetShoes: true,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 20,
            child: Text('Lunes 10', style: TextStyle(color: Colors.black),),
          )
        ],
      ),
    );
  }
}
