import 'package:adminui/models/BookedDatesResponse.dart';
import 'package:adminui/showMenu.dart';
import 'package:flutter/foundation.dart';

//import 'package:adminui/models/playerinfo.dart';
import 'package:flutter/material.dart';
import 'package:adminui/repository/UserRepository.dart';
import 'package:adminui/models/UsersResponse.dart';
import 'package:adminui/models/User.dart';
import 'package:adminui/models/Match.dart';
import 'package:adminui/models/PlayersinfoandBookedDate.dart';
import 'package:adminui/models/playerinfo.dart';
import 'package:adminui/Calendar.dart';
import 'dart:convert';

//at end of the year look for hardcoded date

class adminui extends StatefulWidget {
  @override
  _adminuiState createState() => _adminuiState();
}

class _adminuiState extends State<adminui> {
  bool _value = false;
  int index = -1;

  late UsersResponse response;
  late BookedDatesResponse bookingsresp;

  DateTime selectedDate = DateTime.now();
  late List<PlayersinfoandBookedDates> Doubles;

  List<List<PlayersinfoandBookedDates>> columnData = [];
  List<bool> hasCaptain = new List<bool>.filled(12, false);
  final UserRepository _repository = UserRepository();
  List<Calendar>? _DatesMonth;
   DateTime? picked;
  int activeDay = 0;
  bool saveBtnswitchState = false;
  bool startBtnswitchState = true;
  bool gridBtnswitchState = true;
  List<Match> allmatchs = [];
  List<DateTime> dates = [];
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  int yearofmatch = 2023;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) {
      hasCaptain[i] = false;
    }
    //   getMatchs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Landings Team Setup "),
            backgroundColor: Colors.redAccent,
            actions: <Widget>[
              //        IconButton(icon: Icon(Icons.calendar_today), onPressed: showGrid()),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  child: Text("Start",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: startBtnswitchState ? () => {newMonth()} : null),
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveBtnswitchState ? () => {save()} : null),
            ]),
        drawer: showMyMenu(context, [1, 2, 3], _repository),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: BuildColumns())
            //       )
            )
        // )

        );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      List<PlayersinfoandBookedDates> info = columnData[columnData.length - 1];
      PlayersinfoandBookedDates u = info[oldIndex];
      info.removeAt(oldIndex);
      info.insert(newIndex, u);
    });
  }

  setFreeze() async {
    await _repository.freezedatabase();
  }

  newMonth() async {
    List<Widget> items = [];
    int count = 1;
    int? day;
    //we want the calendar to start on first MWF that does not have matchs and must do this step as
    //the datepicker will throw if start date is not one of the selectableDayPredicate (nuts)
    DateTime start = DateTime.now();
    for (int i = 0; i < 31; i++) {
      if (_decideWhichDayToEnable(start)) break;
      start = start.add(new Duration(days: 1));
    }

    picked = await showDatePicker(
        context: context,
        initialDate: start,
        // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        selectableDayPredicate: _decideWhichDayToEnable);
    //get the bookable days in the month
    _DatesMonth = CustomCalendar().getMonthCalendar(
        picked!.month, picked!.day, yearofmatch,
        startWeekDay: StartWeekDay.monday);
    //find the first MWF of selected  month

    day = picked?.day;
    bookingsresp = await _repository.getMonthStatus(picked!);
    startBtnswitchState = false;
    saveBtnswitchState = true;
    addColumn();
  }

  addColumn() async {
    List<PlayersinfoandBookedDates> players =
        getPlayersforDay(bookingsresp.datesandstatus, picked!);
    if (players.length < 4) {
      _showDialog('no players for this day', false);
      _DatesMonth?.removeAt(0);
      picked = _DatesMonth?.first.date;
      addColumn();
    } else
      setState(() {
        dates.add(picked!);
        columnData.add(players);
      });
  }

  List<Widget> BuildColumns() {
    var widg3;
    List<Widget> dayInfo = [];

    int editablecol = columnData.length - 1;
    int col = 0;
    double width = 400;
    Iterator iter = columnData.iterator;
    while (iter.moveNext()) {
      //   columnData.forEach((list) {
      List<PlayersinfoandBookedDates> list = iter.current;
      if (col > 30) break;
      //  if (list.first.day == selectedDate.day)
      //       var tt =0;
      String p = months[list.first.Month! - 1] + ' ' + dates[col].day.toString();
      width = 400;
      if (col != editablecol) width = 200;
      widg3 =
          new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //         Expanded(
        //           child:
        Container(
            width: width,
            height: 70,
            child: Column(children: [
              Center(
                child: Text(p,
                    style: TextStyle(
                      //                  height: 3.0,
                      fontSize: 15.2,
                      fontWeight: FontWeight.bold,
                    )),

                //   Text('March 9', style: TextStyle(height: 3.0, fontSize: 21.2, fontWeight: FontWeight.bold,)),
              ),
              //           Row(children: [
              ListTile(
                  key: ValueKey(0),
                  title: Row(children: <Widget>[
                    col == editablecol
                        ? Flexible(
                            flex: 3, fit: FlexFit.tight, child: Text("  Name"))
                        : Container(),
                    col == editablecol
                        ? Flexible(
                            flex: 1, fit: FlexFit.tight, child: Text("times"))
                        : Container(),
                    col == editablecol
                        ? Flexible(
                            flex: 1, fit: FlexFit.tight, child: Text("level"))
                        : Container(),
                    col == editablecol
                        ? Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text("captain "))
                        : Container(),
                  ]
                      //         ),
                      //   Text('March 9', style: TextStyle(height: 3.0, fontSize: 21.2, fontWeight: FontWeight.bold,)),
                      )),
            ])),
        Expanded(
            child: Container(
                width: width,
                height: 1200,
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            width: 6,
                            color: Colors.white,
                            style: BorderStyle.solid))),
                child: col == editablecol
                    ? ReorderableListView(
                        onReorder: onReorder,
                        children: getPlayers(list, col, editablecol),
                      )
                    : ListView(
                        children: getPlayers(list, col, editablecol),
                      )))
      ]);
      col++;
      if (col > 7) dayInfo.removeAt(0);
      dayInfo.add(widg3);
    }

    return dayInfo;
  }

  save() async {
    List<Match> matches = [];
    List<PlayersinfoandBookedDates> info = columnData[columnData.length - 1];
    int count = 1;
    int playercnt = 0;
    List<String> players = [];
    String? Captain = "not";
    for (int i = 0; i < info.length; i++) {
      double width = 0;

      if (info[i].bIsCaptain == true) Captain = info[i].user?.Name;
      players.add(info[i].user!.Name!);
      if (count % 4 == 0) {
        if (Captain == "not") {
          _showDialog('all matchs must have a Captain', true);
          return;
        }
        Match m = new Match();
        m.id = 1;
        m.day = picked?.day;
        m.month = picked?.month;
        m.year = picked?.year;
        m.level = 1;
        m.Captain = Captain;

        m.players = players;
        matches.add(m);
        players = [];
        Captain = "not";
      }
      ;

      count++;
    }
//   check for players not matched and set level to 99 for them
    if (players.length > 0) {
      Match m = new Match();
      m.id = 1;
      m.day = picked?.day;
      m.month = picked?.month;
      m.year = picked?.year;
      m.level = 99;
      m.players = players;
      matches.add(m);
    }

    response = await _repository.saveMatches(matches);

    //the first column becomes new day to be editted
    _DatesMonth?.removeAt(0);
    if (_DatesMonth!.isEmpty) {
      _showDialog('that all Folks', false);
      return;
    }
    picked = _DatesMonth?.first.date;
    bookingsresp = await _repository.getMonthStatus(picked!); //CLUDGE
    //no captains assigned by default
    for (int i = 0; i < 12; i++) {
      hasCaptain[i] = false;
    }
    addColumn();
  }

  List<PlayersinfoandBookedDates> getPlayersforDay(
      List<PlayersinfoandBookedDates> datesandstatus, DateTime selectedDate) {
    int count = 1;
    List<PlayersinfoandBookedDates> playersforday = [];
    for (int i = 0; i < datesandstatus.length; i++) {
      List<String>? daystatus = datesandstatus[i].status?.split(',');
      if (daystatus?[selectedDate.day] != '0')
        continue; //only thos avaiable and want to play

      //need new reference
      //   PlayersinfoandBookedDates newInfo = PlayersinfoandBookedDates.fromJson(datesandstatus[i].toJson());;
      //    newInfo.user = User.fromJson(datesandstatus[i].user.toJson());;
      datesandstatus[i].bIsCaptain = false;
      datesandstatus[i].day = selectedDate.day;
      playersforday.add(datesandstatus[i]);
    }
 //   playersforday.sort((a, b) => a.user?.level?.compareTo(b.user.level));
    ;
    return playersforday;
    ;
  }

  bool _decideWhichDayToEnable(DateTime day) {
    List<Match> filter = allmatchs
        .where(
            (element) => element.month == day.month && element.day == day.day)
        .toList();
    if (filter.length > 0) return false;
    if (day.weekday == 1 || day.weekday == 3 || day.weekday == 5) return true;
    return false;
  }

  void _showDialog(String err, bool isError) {
    String message = "";
    if (isError) message = "internal logic error";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message),
          content: new Text(err),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> getPlayers(
      List<PlayersinfoandBookedDates> playersforday, int col, editablecol) {
    List<Widget> items = [];

    int count = 1;
    int teams = 0;
    var back = Colors.black;
    if (col != editablecol) back = Colors.grey;
    for (int i = 0; i < playersforday.length; i++) {
      double width = 0;
      //can only have one captain per team
      if (count % 4 == 0) width = 16;

      count++;
      var temp = Column(
        key: ValueKey(i),
        //set mainAxisSize to min to avoid items disappearing on reorder
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: back,
                border: Border(
                    bottom: BorderSide(
                        width: width,
                        color: Colors.blueGrey,
                        style: BorderStyle.solid))),
            child: ListTile(
              key: ValueKey(i),
              title: Row(children: <Widget>[
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Text(playersforday[i].user!.Name!)),
                col == editablecol
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                            playersforday[i].user!.timesCaptain.toString() +
                                ' ' +
                                playersforday[i].user!.notused.toString()))
                    : Container(),
                col == editablecol
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(playersforday[i].user!.level.toString()))
                    : Container(),
                col == editablecol
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Checkbox(
                            value: playersforday[i].bIsCaptain,
                            onChanged: (value) {
                              setState(() {
                                int teamnumber = (i ~/ 4);
                                bool captainassigned = hasCaptain[teamnumber];

                                if (value == true) {
                                  if (captainassigned) {
                                    _showDialog(
                                        "only one captain per team", true);
                                    return;
                                  }

                                  playersforday[i].user?.timesCaptain += 1;
                                  hasCaptain[teamnumber] = true;
                                } else {
                                  playersforday[i].user?.timesCaptain -= 1;
                                  hasCaptain[teamnumber] = false;
                                }
                                playersforday[i].bIsCaptain =
                                    !playersforday[i].bIsCaptain;
                              });
                            }))
                    : Container(),
              ]),
              //    controlAffinity: ListTileControlAffinity.leading,
              autofocus: false,
              //     activeColor: Colors.green,
              //     checkColor: Colors.white,
              selected: index == i,
              //     value: index == i,
              //     onChanged: (bool value) {
              //      setState(() {
              //       index = i;
              //      _value = true;
              //       });
              //      }
            ),
            //        i % 4 == 0 ?Divider(height:100) :Divider(height:0)
          )
        ],
      );
      items.add(temp);
    }

    return items;
  }
}
