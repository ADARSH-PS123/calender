import 'dart:developer';

import 'package:flutter/material.dart';

/// user for DateTime formatting
import 'package:intl/intl.dart';

/// `const CustomCalendar({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   this.startEndDateChange,
///   this.minimumDate,
///   this.maximumDate,
///   required this.primaryColor,
/// })`
class CustomCalendar extends StatefulWidget {
  /// The minimum date that can be selected on the calendar

  /// The maximum date that can be selected on the calendar

  /// The initial start date to be shown on the calendar

  /// The initial end date to be shown on the calendar

  /// The primary color to be used in the calendar's color scheme
  final Color primaryColor;

  /// A function to be called when the selected date range changes
  final Function(DateTime, DateTime)? startEndDateChange;
  final DateTime? minimumDate, maximumDate;
  final List<Streak> streaks;
  final List<DateTime> pendingDates;

  const CustomCalendar({
    Key? key,
    this.startEndDateChange,
    required this.primaryColor,
    required this.streaks,
    this.minimumDate,
    this.maximumDate,
    required this.pendingDates,
  }) : super(key: key);

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  List<Streak> streaks = [];

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    streaks = widget.streaks;
    super.initState();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime previousMothDay =
        DateTime(monthDate.year, monthDate.month, 0); //last month weekday

    int newDate = 0; //week like sunday
    if (previousMothDay.weekday < 6) {
      newDate = previousMothDay.weekday + 1;
      for (int i = 1; i <= newDate; i++) {
        //gets previous month days
        dateList.add(previousMothDay.subtract(Duration(days: newDate - i)));
      }
    } else if (previousMothDay.weekday == 7) {
      log('==============');
      newDate = 1;
      for (int i = 1; i <= newDate; i++) {
        //gets previous month days
        dateList.add(previousMothDay.subtract(Duration(days: newDate - i)));
      }
    }
    for (int i = 0; i < (42 - newDate); i++) {
      dateList.add(previousMothDay.add(Duration(days: i + 1)));
    }

    final ls = dateList.sublist(0, 7);

    final getPreviousMonthdatesLength =
        ls.where((element) => element.month != monthDate.month).length;

    final result = getPreviousMonthdatesLength +
        getDaysInMonth(monthDate.year, monthDate.month);

    if (result <= 35) {
      dateList.length -= 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        setState(() {
                          currentMonthDate = DateTime(
                              currentMonthDate.year, currentMonthDate.month, 0);
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('MMMM').format(currentMonthDate),
                    style: const TextStyle(
                      color: Color(0xFF192966),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        setState(() {
                          currentMonthDate = DateTime(currentMonthDate.year,
                              currentMonthDate.month + 2, 0);
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(
            children: getDaysNameUI(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: getDaysNoUI(),
          ),
        ),
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(dateList[i]),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.primaryColor),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: !isEndDateRadius(date),
                    child: Positioned(
                      top: 14,
                      left: 0,
                      right: 0,
                      height: 3,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: getIsItStartAndEndDate(date) ||
                                    getIsInRange(date)
                                ? const Color(0xFF1C9D67)
                                : Colors.transparent),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        if (currentMonthDate.month == date.month) {
                          if (widget.minimumDate != null &&
                              widget.maximumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isAfter(newminimumDate) &&
                                date.isBefore(newmaximumDate)) {}
                          } else if (widget.minimumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            if (date.isAfter(newminimumDate)) {}
                          } else if (widget.maximumDate != null) {
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isBefore(newmaximumDate)) {}
                          } else {}
                        }
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: isSomeComplete(date)
                              ? Colors.white
                              : getIsItStartAndEndDate(date) ||
                                      getIsInRange(date)
                                  ? currentMonthDate.month == date.month
                                      ? const Color(0xFFB5E1B2)
                                      : const Color(0xFFE1E1E1)
                                  : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32.0)),
                          border: Border.all(
                            color: isSameDay(date)
                                ? const Color(0xFF3B61F4)
                                : getIsItStartAndEndDate(date) ||
                                        getIsInRange(date)
                                    ? currentMonthDate.month == date.month
                                        ? const Color(0xFF1C9D67)
                                        : const Color(0xFF9D9D9D)
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: currentMonthDate.month == date.month
                                    ? const Color(0xFF192966)
                                    : const Color(0xFF192966).withOpacity(.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            isPendingday(date) || isSomeComplete(date)
                                ? Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const ShapeDecoration(
                                      color: Color(0xFFDB5656),
                                      shape: OvalBorder(),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool isSameDay(DateTime date) {
    return DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;
  }

  bool isPendingday(DateTime date) {
    bool status = false;

    for (int i = 0; i < widget.pendingDates.length; i++) {
      if (widget.pendingDates[i].day == date.day &&
          widget.pendingDates[i].month == date.month &&
          widget.pendingDates[i].year == date.year) {
        status = true;
        break;
      }
    }

    return status;
  }

  bool isSomeComplete(DateTime date) {
    bool status = false;

    for (int x = 0; x < streaks.length; x++) {
      for (int i = 0; i < streaks[x].someComplete.length; i++) {
        if (streaks[x].someComplete[i].day == date.day &&
            streaks[x].someComplete[i].month == date.month &&
            streaks[x].someComplete[i].year == date.year) {
          status = true;
          break;
        }
      }
    }

    return status;
  }

  bool getIsInRange(DateTime date) {
    bool status = false;
    for (int i = 0; i < streaks.length; i++) {
      if (date.isAfter(streaks[i].streakStartdate) &&
          date.isBefore(streaks[i].streakEndDate)) {
        status = true;
        break;
      }
    }
    return status;
  }

  bool getIsItStartAndEndDate(DateTime date) {
    bool status = false;
    for (int i = 0; i < streaks.length; i++) {
      final startDate = streaks[i].streakStartdate;
      final endDate = streaks[i].streakEndDate;
      if (startDate.day == date.day &&
          startDate.month == date.month &&
          startDate.year == date.year) {
        status = true;
        break;
      } else if (endDate.day == date.day &&
          endDate.month == date.month &&
          endDate.year == date.year) {
        status = true;
        break;
      } else {
        status = false;
      }
    }

    return status;
  }

  bool isStartDateRadius(DateTime date) {
    bool status = false;
    for (int i = 0; i < streaks.length; i++) {
      final startDate = streaks[i].streakStartdate;

      if (startDate.day == date.day && startDate.month == date.month) {
        status = true;
        break;
      } else if (date.weekday == 7) {
        status = true;
        break;
      } else {
        status = false;
      }
    }
    return status;
  }

  bool isEndDateRadius(DateTime date) {
    bool status = false;
    for (int i = 0; i < streaks.length; i++) {
      final endDate = streaks[i].streakEndDate;
      if (endDate.day == date.day && endDate.month == date.month) {
        status = true;
        break;
      } else if (date.weekday == 6) {
        status = true;
        break;
      } else {
        status = false;
      }
    }

    return status;
  }

  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}

class Streak {
  final List<DateTime> someComplete;
  final DateTime streakStartdate, streakEndDate;

  const Streak(
      {required this.streakEndDate,
      required this.someComplete,
      required this.streakStartdate});
}
