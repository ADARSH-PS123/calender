import 'package:flutter/material.dart';
import 'package:tester/calender/custom_calender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, bottom: 16, top: 50, right: 16),
          child: Material(
            color: Colors.transparent,
            child: CustomCalendar(
              streaks: List.generate(
                  3,
                  (index) => Streak(
                      streakEndDate:
                          DateTime.now().add(Duration(days: index * 10 + 8)),
                      pendingDates: [],
                      someComplete: [],
                      streakStartdate:
                          DateTime.now().add(Duration(days: index * 10)))),
              primaryColor: Colors.black,
              someComplete: [
                DateTime.now().add(const Duration(days: 2)),
                DateTime.now().add(const Duration(days: 3)),
              ],
              pendingDates: [
                DateTime.now().subtract(const Duration(days: 2)),
                DateTime.now().subtract(const Duration(days: 3)),
                DateTime.now()
              ],
              minimumDate: DateTime.now().subtract(const Duration(days: 15)),
              maximumDate: DateTime.now().add(const Duration(days: 15)),
              initialStartDate: DateTime.now().add(const Duration()),
              initialEndDate: DateTime(2023, 10, 10),
            ),
          ),
        ),
      ),
    );
  }
}
