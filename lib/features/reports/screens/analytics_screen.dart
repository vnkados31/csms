// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

import '../../../constants/global_variables.dart';

class UserCounts {
  final int vegUsers;
  final int nonVegUsers;
  final int dietUsers;

  UserCounts({
    required this.vegUsers,
    required this.nonVegUsers,
    required this.dietUsers,
  });
}

class MyAnalytics extends StatefulWidget {
  final String date1;
  final String date2;
  const MyAnalytics({
    Key? key,
    required this.date1,
    required this.date2,
  }) : super(key: key);

  @override
  State<MyAnalytics> createState() => _MyAnalyticsState();
}

class _MyAnalyticsState extends State<MyAnalytics> {
  late int veg = 0;
  late int nonVeg = 0;
  late int diet = 0;

  Future<UserCounts> fetchUserCounts(String date1, String date2) async {
    final response = await http.get(
      Uri.parse('$uri/user-counts/lunch?date1=$date1&date2=$date2'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        veg = data['vegUsers'];
        nonVeg = data['nonVegUsers'];
        diet = data['dietUsers'];
      });
      return UserCounts(
        vegUsers: data['vegUsers'] ?? 0,
        nonVegUsers: data['nonVegUsers'] ?? 0,
        dietUsers: data['dietUsers'] ?? 0,
      );
    } else {
      throw Exception('Failed to load user counts');
    }
  }

// Data for the pie chart

// Colors for each segment
// of the pie chart
  List<Color> colorList = [
    const Color.fromRGBO(129, 250, 112, 1),
    const Color.fromRGBO(175, 63, 62, 1.0),
    const Color.fromRGBO(91, 253, 199, 1),
  ];
  Map<String, double> dataMap = {
    "Veg": 0,
    "Non-Veg": 0,
    "Diet": 0,
  };
// List of gradients for the
// background of the pie chart
  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ]
  ];

  @override
  void initState() {
    super.initState();

    fetchUserCounts(widget.date1, widget.date2);
  }

  @override
  Widget build(BuildContext context) {
    double vegUsersDouble = veg.toDouble();
    double nonVegUsersDouble = nonVeg.toDouble();
    double dietUsersDouble = diet.toDouble();

    dataMap = {
      "Veg": vegUsersDouble,
      "Non-Veg": nonVegUsersDouble,
      "Diet": dietUsersDouble,
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pie Chart example"),
      ),
      body: Center(
        child: PieChart(
          // Pass in the data for
          // the pie chart
          dataMap: dataMap,
          // Set the colors for the
          // pie chart segments
          colorList: colorList,
          // Set the radius of the pie chart
          chartRadius: MediaQuery.of(context).size.width / 1.3,
          // Set the center text of the pie chart
          centerText: "Lunch",
          // Set the width of the
          // ring around the pie chart
          ringStrokeWidth: 24,
          // Set the animation duration of the pie chart
          animationDuration: const Duration(seconds: 3),
          // Set the options for the chart values (e.g. show percentages, etc.)
          chartValuesOptions: const ChartValuesOptions(
              showChartValues: true,
              showChartValuesOutside: true,
              showChartValuesInPercentage: false,
              showChartValueBackground: false),
          // Set the options for the legend of the pie chart
          legendOptions: const LegendOptions(
              showLegends: true,
              legendShape: BoxShape.rectangle,
              legendTextStyle: TextStyle(fontSize: 15),
              legendPosition: LegendPosition.bottom,
              showLegendsInRow: true),
          // Set the list of gradients for
          // the background of the pie chart
          gradientList: gradientList,
        ),
      ),
    );
  }
}
