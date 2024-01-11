// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';

class SnacksScannedUsersCountScreen extends StatefulWidget {
  final String date1;
  final String date2;
  const SnacksScannedUsersCountScreen({
    Key? key,
    required this.date1,
    required this.date2,
  }) : super(key: key);

  @override
  _SnacksScannedUsersCountScreenState createState() =>
      _SnacksScannedUsersCountScreenState();
}

class _SnacksScannedUsersCountScreenState
    extends State<SnacksScannedUsersCountScreen> {
  String resultMessage = '';
  List<dynamic> resultData = [];

  int totalSnacksCount = 0;

  Future<void> fetchScannedUsersCount(String date1, String date2) async {
    final String apiUrl = '$uri/user-counts/snacks?date1=$date1&date2=$date2';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          resultMessage = responseData['message'];
          resultData = responseData['result'];
          totalSnacksCount = resultData[0]['scannedUsersCount'];
        });
      } else {
        setState(() {
          resultMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        resultMessage = 'Failed to connect to the server';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchScannedUsersCount(widget.date1, widget.date2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Users Count'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              'SnacksTotalCount: $totalSnacksCount',
              style: const TextStyle(color: Colors.black, fontSize: 30),
            )),
          ],
        ),
      ),
    );
  }
}
