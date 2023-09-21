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
  final DateTime? minimumDate;
  final List<DateTime> pendingDates, someComplete;

  /// The maximum date that can be selected on the calendar
  final DateTime? maximumDate;

  /// The initial start date to be shown on the calendar
  final DateTime? initialStartDate;

  /// The initial end date to be shown on the calendar
  final DateTime? initialEndDate;

  /// The primary color to be used in the calendar's color scheme
  final Color primaryColor;

  /// A function to be called when the selected date range changes
  final Function(DateTime, DateTime)? startEndDateChange;
  final List<Streak> streaks;

  const CustomCalendar({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    this.startEndDateChange,
    this.minimumDate,
    this.maximumDate,
    required this.primaryColor,
    required this.pendingDates,
    required this.someComplete, required this.streaks,
  }) : super(key: key);

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);

    int previousMothDay = 0; //week like sunday
    if (newDate.weekday < 6) {
      //!sunday
      previousMothDay = newDate.weekday + 1;
      for (int i = 1; i <= previousMothDay; i++) {
        //gets previous month days
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
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
                          color: startDate != null && endDate != null
                              ? getIsItStartAndEndDate(date) ||
                                      getIsInRange(date)
                                  ? const Color(0xFF1C9D67)
                                  : Colors.transparent
                              : Colors.transparent,
                        ),
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
                          color: isPendingdayOrSomeComplete(
                                  date, widget.someComplete)
                              ? Colors.white
                              : getIsItStartAndEndDate(date) ||
                                      getIsInRange(date)
                                  ? const Color(0xFFB5E1B2)
                                  : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32.0)),
                          border: Border.all(
                            color: isSameDay(date)
                                ? const Color(0xFF3B61F4)
                                : getIsItStartAndEndDate(date) ||
                                        getIsInRange(date)
                                    ? const Color(0xFF1C9D67)
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
                            isPendingdayOrSomeComplete(
                                    date, widget.pendingDates)
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

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isSameDay(DateTime date) {
    return DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;
  }

  bool isPendingdayOrSomeComplete(DateTime date, List<DateTime> dates) {
    bool status = false;
    for (int i = 0; i < dates.length; i++) {
      if (dates[i].day == date.day &&
          dates[i].month == date.month &&
          dates[i].year == date.year) {
        status = true;
        break;
      }
    }

    return status;
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 6) {
      return true;
    } else {
      return false;
    }
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
  final List<DateTime> someComplete, pendingDates;
  final DateTime streakStartdate, streakEndDate;

  const Streak(
      {required this.streakEndDate,
      required this.pendingDates,
      required this.someComplete,
      required this.streakStartdate});
}