import 'dart:convert';

import 'package:csm_system/features/hr_report/services/hr_services.dart';
import 'package:csm_system/features/profile/screens/profile_screen.dart';
import 'package:csm_system/features/settings/services/settings_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsServices settingServices = SettingsServices();
  final HrSevices hrSevices = HrSevices();

  void _showAlertDialog(BuildContext context, String foodType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowDialog(foodType: foodType);
      },
    );
  }

  // void addCoupons(User user) async {
  //   settingServices.addCoupons(context: context, user: user, onSuccess: () {});
  // }

  Future<void> addCoupons(int psNumber) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    final response = await http.put(
      Uri.parse('$uri/api/add-coupons/$psNumber'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      setState(() {
        showSnackBar(context, '25 Coupons added Succesfully!');
      });
    } else {
      setState(() {
        showSnackBar(context, 'Coupons not added!');
      });
    }

    hrSevices.addCouponsBookRecord(
        context: context,
        psNumber: psNumber,
        date: formattedDate,
        onSuccess: () {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        color: Colors.white54,
                        elevation: 10,
                        shadowColor: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            // User Profile Picture
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('asset/images/person.png'),
                              radius: 50,
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 10),
                            // Add some space between the picture and details
                            // User Details (Name and ID) in a Column
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${user.name}',
                                  style: const TextStyle(fontSize: 25),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                // Add some space between the name and ID
                                Text(
                                  'PS No.: ${user.psNumber}',
                                  style: const TextStyle(fontSize: 25),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    // Add padding to all ListTile items
                    child: ListTile(
                      onTap: () {
                        _showAlertDialog(context, user.foodType.toString());
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.restaurant),
                      ),
                      title: const Text(
                        'Change Diet',
                        style: TextStyle(fontSize: 30),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    // Add padding to all ListTile items
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Add Coupons',
                                  style: TextStyle(fontSize: 30),
                                ),
                                content: Container(
                                    child: const Text(
                                  'Are you sure to add 25 Coupons?',
                                  style: TextStyle(fontSize: 26),
                                )),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(fontSize: 24),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        int psNumber = user.psNumber;

                                        if (user.couponsLeft > 35) {
                                          showSnackBar(context,
                                              'Already have enough Coupons!');
                                        } else {
                                          await addCoupons(psNumber);
                                        }
                                        Navigator.pop(context);

                                        //await _addCoupons(_user!.email);
                                      },
                                      child: const Text('Yes',
                                          style: TextStyle(fontSize: 24)))
                                ],
                              );
                            });
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.add),
                      ),
                      title: const Text(
                        'Add Coupons',
                        style: TextStyle(fontSize: 30),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    // Add padding to all ListTile items
                    child: ListTile(
                      onTap: () {
                        // FirebaseAuth.instance.signOut().then((value) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const LoginScreen()));
                        // }).onError((error, stackTrace) {
                        //   Utils().toastMessage(error.toString());
                        // });
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.logout),
                      ),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(fontSize: 30),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  final String foodType;
  const ShowDialog({super.key, required this.foodType});

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  late String _selectedFoodType = '';
  final SettingsServices settingServices = SettingsServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedFoodType = widget.foodType;
  }

  Future<void> changeFoodType(int psNumber, String foodTypeUpdated) async {
    final response = await http.put(
      Uri.parse('$uri/api/change-food-type/$psNumber'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'foodType': foodTypeUpdated}),
    );

    if (response.statusCode == 200) {
      setState(() {
        showSnackBar(context, 'Food type updated Succesfully!');
      });
    } else {
      setState(() {
        showSnackBar(context, 'Not updated !');
      });
    }
  }

  // void changeFoodType(User user, String foodTypeUpdated) {
  //   settingServices.changeFoodType(
  //       context: context,
  //       foodTypeUpdated: foodTypeUpdated.toString(),
  //       psNumber: user.psNumber,
  //       onSuccess: () {
  //         setState(() {});
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return AlertDialog(
      title: const Text(
        'Change Food Type',
        style: TextStyle(fontSize: 30),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Radio<String>(
              // activeColor: Colors.deepOrangeAccent,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.green),
              value: 'Veg',
              groupValue: _selectedFoodType,
              onChanged: (value) {
                setState(() {
                  _selectedFoodType = value!;
                });
              },
            ),
            title: const Text('Veg', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            leading: Radio<String>(
              fillColor: MaterialStateColor.resolveWith((states) => Colors.red),
              value: 'NonVeg',
              groupValue: _selectedFoodType,
              onChanged: (value) {
                setState(() {
                  _selectedFoodType = value!;
                });
              },
            ),
            title: const Text(
              'NonVeg',
              style: TextStyle(fontSize: 24),
            ),
          ),
          ListTile(
            leading: Radio<String>(
              value: 'Diet',
              groupValue: _selectedFoodType,
              onChanged: (value) {
                setState(() {
                  _selectedFoodType = value!;
                });
              },
            ),
            title: const Text('Diet', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 26),
            )),
        TextButton(
            onPressed: () async {
              int psNumber = user.psNumber;
              await changeFoodType(psNumber, _selectedFoodType);
              Navigator.pop(context);
              //await _changeFoodType(widget.str);
            },
            child: const Text('Update', style: TextStyle(fontSize: 26)))
      ],
    );
  }

  // Future<void> _changeFoodType(String? str) async {
  //   final firestoreInstance = FirebaseFirestore.instance;
  //   final collectionReference =
  //       firestoreInstance.collection('canteen_database');

  //   // Query Firestore to find the document with the unique field
  //   final querySnapshot =
  //       await collectionReference.where('email', isEqualTo: str).get();

  //   //print(querySnapshot);
  //   if (querySnapshot.docs.isNotEmpty) {
  //     final documentReference = querySnapshot.docs.first.reference;

  //     // Fetch the current 'coupons_left' value
  //     final currentData = await documentReference.get();

  //     if (currentData.exists) {
  //       await documentReference
  //           .update({
  //             'food_type': _selectedFoodType,
  //           })
  //           .then((_) {})
  //           .catchError((error) {});
  //     } else {
  //       // print('Document not found');
  //     }
  //   } else {
  //     //print('Document not found');
  //   }
  // }
}
