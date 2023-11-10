import 'dart:convert';

import 'package:csm_system/models/qrmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class QrScannerServices {
  void addToList(
      {required BuildContext context,
      required String name,
      required String email,
      required int psNumber,
      required int vegUsers,
      required int nonVegUsers,
      required int dietUsers,
      required int totalUsers,
      required int scannedBy,
      required int couponsLeft,
      required String date}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Qrmodel qrmodel = Qrmodel(
          name: name,
          email: email,
          psNumber: psNumber,
          vegUsers: vegUsers,
          nonVegUsers: nonVegUsers,
          dietUsers: dietUsers,
          totalUsers: totalUsers,
          scannedBy: scannedBy,
          couponsLeft: couponsLeft,
          date: date);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/scan-qr'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: qrmodel.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'User Scanned Successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> deductCoupons(
      {required BuildContext context,
      required int psNumber,
      required int totalUsers}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/deduct-coupons'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"psNumber": psNumber, "couponsToDeduct": totalUsers}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Coupons deducted successfully");
        },
      );

      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      // showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<List<Qrmodel>> fetchAllScannedUsers(
      BuildContext context, int psNumber, String day) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Qrmodel> scannedUsersList = [];
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/admin/get-scanned-users'),
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
              Qrmodel.fromJson(
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

// here onSuccess callback method will help us in deleting product

  void deleteScannedUser(
      {required BuildContext context,
      required Qrmodel scannedUser,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-scanned-users'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': scannedUser.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
