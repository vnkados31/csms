import 'dart:convert';
import 'package:csm_system/models/menuitem.dart';
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
      required String type}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      MenuItem menuItem = MenuItem(name: name, day: day, type: type);

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

  Future<List<MenuItem>> fetchMenuItems(
      BuildContext context, String selectedDay, String foodType) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<MenuItem> menuItemsList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-menu-items'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            MenuItem menuItem = MenuItem.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            );

            if (menuItem.day == selectedDay && menuItem.type == foodType) {
              menuItemsList.add(menuItem);
            }
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
      required String name,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/update-menu-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': menuItem.id, 'name': name.toString()}),
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

  Future<bool> checkFoodType({
    required BuildContext context,
    required String selectedDay,
    required String foodType,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/check-food-type'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'day': selectedDay, 'type': foodType}),
      );

      if (res.statusCode == 200) {
        return true;
      } else if (res.statusCode == 400) {
        return false;
      } else {
        // Handle other status codes as needed
        // You might want to throw an exception or handle them differently.
        return false;
      }
    } catch (e) {
      // Handle network or other errors here
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
