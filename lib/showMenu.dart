import 'package:adminui/repository/UserRepository.dart';
import 'package:flutter/material.dart';

Drawer showMyMenu(context,List<int> indexes ,UserRepository _repository){

  var items = <Widget>[];
  var header = new Container(
    height: 20.0,
    child: DrawerHeader(

        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(0.0), child: null,
    ),
  );
  items.add(header);

  indexes.forEach((i) {
    var tile;
    switch (i) {
      case 1:
        tile = new ListTile(
          title: Text('Zero captain counts'),
              onTap : () async  {
                await _repository.zeroCaptainCount();
          },
        );
        break;
      case 2:
        tile = new ListTile(
          title: Text('Freeze DB'),
          onTap: ()  async {
            await _repository.freezedatabase();

          },
        );
        break;

      case 3:
        tile = new ListTile(
          title: Text('Unfreeze DB'),
          onTap: () async {
            await _repository.freezedatabase();

          },
        );
        break;


    }
    items.add(tile);

  });
  return Drawer(child: ListView(children: items));
}