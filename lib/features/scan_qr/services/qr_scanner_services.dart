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
      required double psNumber,
      required double vegUsers,
      required double nonVegUsers,
      required double dietUsers,
      required double totalUsers,
      required double scannedBy,
      required double couponsLeft
      }) async {
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
          couponsLeft: couponsLeft
          );

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
          Navigator.pop(context);
        },
      );

      
    } catch (e) {
          showSnackBar(context, e.toString());
    }
  }
}
