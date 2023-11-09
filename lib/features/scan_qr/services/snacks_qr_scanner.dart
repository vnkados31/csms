import 'dart:convert';

import 'package:csm_system/models/snacks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class SnacksQrScannerServices {
  void addToSnacksList(
      {required BuildContext context,
      required String name,
      required int psNumber,
      required int scannedBy,
      required String date}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Snacks snacks = Snacks(
          name: name,
          psNumber: psNumber,
          scannedBy: scannedBy,
          date: date);

      http.Response res = await http.post(
        Uri.parse('$uri/snacks/save-user'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: snacks.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Snacks User Scanned Successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  

  Future<List<Snacks>> fetchAllSnacksScannedUsers(
      BuildContext context, int psNumber, String day) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Snacks> scannedUsersList = [];
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/snacks/check-scanned-user'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({'scannedBy': psNumber, 'date': day.toString()}));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            scannedUsersList.add(
              Snacks.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return scannedUsersList;
  }

  Future<bool> checkSnacksUser(BuildContext context, int psNumber, String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse('$uri/snacks/check-scanned-user'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({'psNumber': psNumber, 'date': date}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["found"] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      showSnackBar(context, '${response.statusCode}');
      return false;
    }
  }

}
