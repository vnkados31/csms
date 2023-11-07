import 'package:csm_system/features/generate_qr/screens/qr_screen.dart';
import 'package:csm_system/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../menu/services/menu_services.dart';

class GenerateQrScreen extends StatefulWidget {
  static const String routeName = '/generateqr';
  const GenerateQrScreen({super.key});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

enum UserDiet {
  veg,
  nonVeg,
  diet,
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  List<dynamic> dataToSend = [];
  int users = 0;
  int vegUsers = 0;
  int nonVegUsers = 0;
  int dietUsers = 0;
  int totalUsers = 0;
  UserDiet selectedDiet = UserDiet.veg;

  late String email;
  late String name;
  late bool vegData = true;
  late bool nonVegData = false;
  late bool dietData = false;

  final MenuServices menuServices = MenuServices();

  void assingningData(int psNumber, int couponsLeft) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    setState(() {
      dataToSend.clear();
      dataToSend.add(name);
      dataToSend.add(email);
      dataToSend.add(psNumber);
      dataToSend.add(vegUsers);
      dataToSend.add(nonVegUsers);
      dataToSend.add(dietUsers);
      dataToSend.add(totalUsers);
      dataToSend.add(couponsLeft);
      dataToSend.add(formattedDate);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFoodType();
  }

  void checkFoodType() async {
    DateTime date = DateTime.now();
    String weekDay = DateFormat('EEEE').format(date);
    nonVegData = await menuServices.checkFoodType(
        context: context, selectedDay: weekDay, foodType: "NonVeg");
    dietData = await menuServices.checkFoodType(
        context: context, selectedDay: weekDay, foodType: "Diet");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    name = user.name;
    email = user.email;

    List<DropdownMenuItem<UserDiet>> dropdownItems = [
      const DropdownMenuItem<UserDiet>(
        value: UserDiet.veg,
        child: Center(child: Text('Veg')),
      ),
    ];

    if (nonVegData) {
      // Add the "Non-Veg" item only if it's not Wednesday, Friday, or Saturday.
      dropdownItems.add(
        const DropdownMenuItem<UserDiet>(
          value: UserDiet.nonVeg,
          child: Center(child: Text('Non-Veg')),
        ),
      );
    }

    if (dietData) {
      dropdownItems.addAll([
        const DropdownMenuItem<UserDiet>(
          value: UserDiet.diet,
          child: Center(child: Text('Diet')),
        ),
      ]);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          final buttonSize = screenHeight * 0.1;
          final mainCounterSize = screenHeight * 0.13;

          return Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    'Select Users',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.amberAccent,
                              width: 2.5,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                        ),
                        child: DropdownButton<UserDiet>(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          style: const TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 33, 32, 32)),
                          value: selectedDiet,
                          onChanged: (UserDiet? newValue) {
                            setState(() {
                              selectedDiet = newValue!;
                              if (selectedDiet == UserDiet.veg) {
                                users = vegUsers;
                              } else if (selectedDiet == UserDiet.nonVeg) {
                                users = nonVegUsers;
                              } else if (selectedDiet == UserDiet.diet) {
                                users = dietUsers;
                              }
                            });
                          },
                          items: dropdownItems,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: decrementUsers,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(buttonSize * 0.4),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                        Text(
                          '$users',
                          style: TextStyle(
                            fontSize: mainCounterSize,
                            color: Colors.orange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: incrementUsers,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(buttonSize * 0.4),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Column(
                    children: [
                      const Text(
                        'Total Users',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Veg: $vegUsers, Non-Veg: $nonVegUsers, Diet: $dietUsers',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: $totalUsers',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton.icon(
                    onPressed: () async {
                      assingningData(user.psNumber, user.couponsLeft);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrScreen(itemList: dataToSend),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.03,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void incrementUsers() {
    if (users < 9) {
      setState(() {
        users++;
        switch (selectedDiet) {
          case UserDiet.veg:
            vegUsers++;
            break;
          case UserDiet.nonVeg:
            nonVegUsers++;
            break;
          case UserDiet.diet:
            dietUsers++;
            break;
        }
        totalUsers = vegUsers + nonVegUsers + dietUsers;
      });
    }
  }

  void decrementUsers() {
    if (users >= 1) {
      setState(() {
        users--;
        switch (selectedDiet) {
          case UserDiet.veg:
            vegUsers--;
            break;
          case UserDiet.nonVeg:
            nonVegUsers--;
            break;
          case UserDiet.diet:
            dietUsers--;
            break;
        }
        totalUsers = vegUsers + nonVegUsers + dietUsers;
      });
    }
  }
}
