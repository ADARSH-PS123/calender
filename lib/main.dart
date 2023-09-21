import 'package:flutter/material.dart';
import 'package:tester/calender/custom_calender.dart';
import 'package:tester/calender/custom_date_picker.dart';

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
              primaryColor: Colors.black,
              minimumDate: DateTime.now().subtract(const Duration(days: 15)),
              maximumDate: DateTime.now().add(const Duration(days: 15)),
              initialStartDate: DateTime.now(),
              initialEndDate: DateTime(2023, 9, 28),
            ),
          ),
        ),
      ),
    );
  }
}
