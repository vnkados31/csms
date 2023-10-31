import 'dart:convert';

import 'package:csm_system/models/menuitem.dart';
import 'package:csm_system/models/qrmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class MenuServices {
  void addMenuItem(
      {required BuildContext context,
      required String name,
      required String day,
      required String type
      }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      MenuItem menuItem = MenuItem(
          name: name,
          day: day,
          type: type
         );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-menu-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: menuItem.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Menu Item added Succesfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<MenuItem>> fetchMenuItems(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<MenuItem> menuItemsList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-menu-items'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            menuItemsList.add(
              MenuItem.fromJson(
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
    return menuItemsList;
  }

// here onSuccess callback method will help us in deleting product

  void deleteMenuItem(
      {required BuildContext context,
      required MenuItem menuItem,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-menu-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': menuItem.id,
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

  void updateMenuItem(
      {required BuildContext context,
      required MenuItem menuItem,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/update-menu-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': menuItem.id,
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
