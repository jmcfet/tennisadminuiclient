import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:adminui/models/Match.dart';



/// The home page of the application which hosts the datagrid.
class UserMatchsDataGrid extends StatefulWidget {
  /// Creates datagrid with selection option(single/multiple and select/unselect)
  ///
  final List<Match> matchs ;
  UserMatchsDataGrid( this.matchs );
  int firstDynamicColumn = 2;
  @override
  _UserMatchsState createState() => _UserMatchsState(matchs);
}

class _UserMatchsState extends State<UserMatchsDataGrid> {
  TennisDataGridSource _tennisDataGridSource;
  final List<Match> matchs ;

  _UserMatchsState(this.matchs);
  @override
  void initState() {
    super.initState();
    _tennisDataGridSource = TennisDataGridSource();
    _tennisDataGridSource.matchs = matchs;
    _tennisDataGridSource.columns = [];
   Match last = null;

    _tennisDataGridSource.columns.add( 'Name');
    _tennisDataGridSource.columns.add( 'PhoneNumber');
    matchs.forEach((match) {
      if (last != null) {
        if (last.day != match.day) {
          _tennisDataGridSource.columns.add( last.day.toString());
        }
      }
      last = match;
    });
    PlayerData playerinfo = new PlayerData();
    _tennisDataGridSource.allPlayers.add(playerinfo);
    playerinfo.name = 'jmcfet@icloud.com';
    int num = 0;
    _tennisDataGridSource.columns.forEach((column)
    {
      int columnNum =  int.tryParse (column) ?? -1;
      if (columnNum >= 0) {
        List<Match> matchsforday = matchs.where((element) =>
        element.day.toString() == column).toList();
        int iNumMatch = 0;
        matchsforday.forEach((matchforday) {
          iNumMatch++;
          for (int ii = 0; ii < 4; ii++) {
            if (matchforday.players[ii] == playerinfo.name) {
              playerinfo.matches[columnNum] = iNumMatch;
              if (matchforday.players[ii] == matchforday.Captain)
                playerinfo.CaptainthatDay[columnNum] = 1;
              break;
            }
          }
        });
      }
    });
    _tennisDataGridSource.playersinfo.add(playerinfo);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter DataGrid Demo'),
        ),
        body:  SfDataGrid(
                  source: _tennisDataGridSource,
                  columns: _tennisDataGridSource.columns
                      .map<GridColumn>((columnName) => GridTextColumn(
                      columnName: columnName,
                      label: Container(
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        child: Text(
                          columnName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )))
                      .toList()
    )
    );

  }
}

class TennisDataGridSource extends DataGridSource {
  List<String> columns = [];
  List<Match> matchs;
  List<DataGridRow> _matchData = [];
  List<PlayerData> playersinfo = [];
  List<PlayerData> allPlayers = [];
  TennisDataGridSource();

  @override
  List<DataGridRow> get rows =>
      playersinfo.map<DataGridRow>((e) {
        List<DataGridCell> cells = [];
        cells.add(DataGridCell<String>(columnName: 'Name', value: e.name),);
        cells.add(DataGridCell<String>(
            columnName: 'PhoneNumber', value: e.PhoneNumber));
        this.columns.forEach((element) {
          //only the dynamic columns have a numeric value
          int columnNum = int.tryParse(element) ?? -1;
          if (columnNum != -1)
            cells.add(DataGridCell<String>(
                columnName: element, value: e.matches[columnNum].toString()));
        });

        return DataGridRow(
            cells: cells);
      }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          Color getColor() {
            int columnNum = int.tryParse(dataGridCell.columnName) ?? -1;
            if (columnNum != -1) {
              PlayerData data = allPlayers[0];
              if (data.CaptainthatDay[columnNum] == 1)
                return Colors.tealAccent;

            }
            return Colors.transparent;
          }


          return Container(
              color: getColor(),
              alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,

              ));
        }).toList());
  }
}

class PlayerData{
  String name;
  String PhoneNumber;
  bool IsCaptain;
  List<int> matches = List<int>(32);
  List<int> CaptainthatDay = List<int>(32);
  PlayerData(){
    IsCaptain = false;
    PhoneNumber = '1234567';
    for (int i = 0; i < 32; i ++) {
      matches[i] = -1;
      CaptainthatDay[i] = -1;
    }
  }
}
