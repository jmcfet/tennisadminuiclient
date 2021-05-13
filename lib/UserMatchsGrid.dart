import 'dart:convert';

import 'package:adminui/repository/UserRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:adminui/models/Match.dart';
import 'package:adminui/models/UsersResponse.dart';

import 'models/User.dart';



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
  Map<String,double> columnswidths = Map();
  final UserRepository _repository = UserRepository();
  final List<Match> matchs ;
  List<User> allusers = [];

  _UserMatchsState(this.matchs);
  @override
  void initState() {
    super.initState();
     getUsersandInitGrid();

  }

  Future <void> getUsersandInitGrid( ) async {
    UsersResponse resp =    await _repository.getUsers();
    allusers = resp.users;
    setState(() {
      _tennisDataGridSource = TennisDataGridSource();
      _tennisDataGridSource.matchs = matchs;
      _tennisDataGridSource.columns = [];
      Match last = null;
      List<String> playersinMonth= [];
      int columnNum = 0;
      _tennisDataGridSource.columns.add( 'Name');
      columnswidths['Name'] = 150;
      _tennisDataGridSource.columns.add( 'EMail');
      columnswidths['EMail'] = 100;
//find each day of month that has matchs and add to the columns list
      matchs.forEach((match) {
        for(int num=0;num < 4; num++)
        {
          if (playersinMonth.isEmpty && match.players[num] != null)
            playersinMonth.add(match.players[num]);
          else if (match.players[num] != null && !playersinMonth.contains(match.players[num]))
            playersinMonth.add(match.players[num]);
        }
        if (!_tennisDataGridSource.columns.contains(match.day.toString())) {

            _tennisDataGridSource.columns.add( match.day.toString());
            columnswidths[match.day.toString()] = 60;

        }
        last = match;
      });
      playersinMonth.forEach((element) {
        PlayerData playerinfo = new PlayerData();
        User user = allusers.where((u) => u.Email == element ).single;
        playerinfo.name = user.Name;

        _tennisDataGridSource.allPlayers.add(playerinfo);


        int num = 0;
        _tennisDataGridSource.columns.forEach((column)
        {
          int columnNum =  int.tryParse (column) ?? -1;  //is this a predefined column (Name,email)
          if (columnNum >= 0) {
            List<Match> matchsforday = matchs.where((element) =>
            element.day.toString() == column).toList();
            int iNumMatch = 0;
            //we are processing member by member . look thru the matchs for this day and see if member is
            //in the match and if they are the captain
            matchsforday.forEach((matchforday) {
              iNumMatch++;
              for (int ii = 0; ii < 4; ii++) {
                User user = allusers.where((u) => u.Email == matchforday.players[ii] ).single;
                if (user.Name == playerinfo.name) {
                  playerinfo.matches[columnNum] = iNumMatch;
                  if (playerinfo.name == matchforday.Captain) {
                    playerinfo.CaptainthatDay[columnNum] = 1;
                  }

                }
              }
            });
          }
        });
        _tennisDataGridSource.playersinfo.add(playerinfo);
      });
    });
    return ;

  }

  @override
  Widget build(BuildContext context) {
   if (_tennisDataGridSource == null)
     return Container();
    return Scaffold(
        appBar: AppBar(
          title: Text('Match info for May'),
        ),
        body:  SfDataGrid(
                  source: _tennisDataGridSource,
                  columns: _tennisDataGridSource.columns
                      .map<GridColumn>((columnName) => GridTextColumn(
                      columnName: columnName,
                      width: columnswidths[columnName],
                      label: Container(
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Text(

                          columnName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                  )
                  )
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
    var playerName = row.getCells()[0].value;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          Color getColor() {
            int columnNum = int.tryParse(dataGridCell.columnName) ?? -1;
            if (columnNum != -1) {
              PlayerData data = allPlayers.where((element) => element.name == playerName).single;;
              if (data.CaptainthatDay[columnNum] == 1)
                return Colors.blue;

            }
            if (columnNum == -1)
              return Colors.grey;
            return Colors.transparent;
          }
          var tt =   dataGridCell.value != '-1' ? dataGridCell.value : '-';

          return Container(
              color: getColor(),
              alignment:
                   Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child:Text(

                  dataGridCell.value != '-1' ? dataGridCell.value : '-',
                  textAlign:TextAlign.center,
                  overflow: TextOverflow.ellipsis,

                ))
              );

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
    PhoneNumber = '123-4567';
    for (int i = 0; i < 32; i ++) {
      matches[i] = -1;
      CaptainthatDay[i] = -1;
    }
  }
}
