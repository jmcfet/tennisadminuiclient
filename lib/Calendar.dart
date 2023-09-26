class CustomCalendar{

  // number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  // check for leap year
  bool _isLeapYear(int year){
    if(year % 4 == 0){
      if(year % 100 == 0){
        if(year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  /// get the month calendar
  /// month is between from 1-12 (1 for January and 12 for December) . we will exclude days other than
  /// M-W-F and those days that already have matchs
  List<Calendar> getMonthCalendar(int month, int day,int year, {StartWeekDay startWeekDay = StartWeekDay.sunday}){

    // validate
    if(year == null || month == null || month < 1 || month > 12) throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = []  ;

    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;

    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if(_isLeapYear(year) && month == DateTime.february) totalDays++;

    // get this month's calendar days
    for(int i=0; i<totalDays; i++){
      DateTime temp = DateTime(year, month, i+1);
      if ((temp.weekday == 1 ||
          temp.weekday == 3 ||
          temp.weekday == 5) && i >= day-1
      )
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
          date: DateTime(year, month, i+1),
          thisMonth: true,
        ),
      );
    }



    return calendar;

  }
}

class Calendar{
  final DateTime date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;
  int state;
  Calendar({
    required this.date,
    this.thisMonth = false,
    this.prevMonth = false,
    this.nextMonth = false,
    this.state = 0
  });
}

enum StartWeekDay {sunday, monday}