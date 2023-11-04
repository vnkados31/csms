import 'package:csm_system/common/widgets/loader.dart';
import 'package:csm_system/features/menu/services/menu_services.dart';
import 'package:csm_system/models/menuitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import 'add_items.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/menu-screen';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String selectedDay;
  late List<String> remainingDays;
  late int currIdxDiff;
  List<MenuItem>? menuItems;
  // List<MenuItem>? filteredItems;

  final MenuServices menuServices = MenuServices();

  @override
  void initState() {
    super.initState();
    remainingDays = getRemainingDays();
    selectedDay = (remainingDays.isNotEmpty ? remainingDays[0] : null)!;
    fetchMenuItems();
  }

  fetchMenuItems() async {
    menuItems =
        await menuServices.fetchMenuItems(context, selectedDay, dropdownValue);
    setState(() {});
  }

  String dropdownValue = 'Veg';

  List<String> getRemainingDays() {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    int currentDayIndex = DateTime.now().weekday - 1;

    List<String> remainingDays = [];

    for (int i = currentDayIndex; i < days.length; i++) {
      remainingDays.add(days[i]);
    }

    return remainingDays;
  }

  void initializePreviousScreen() async {
    selectedDay = (remainingDays.isNotEmpty ? remainingDays[0] : null)!;
    await fetchMenuItems();
    setState(() {});
  }

  void deleteMenuItem(MenuItem menuItem, int index) async {
    menuServices.deleteMenuItem(
        context: context,
        menuItem: menuItem,
        onSuccess: () {
          menuItems!.removeAt(index);
          showSnackBar(context, "Menu Item deleted Successfully");
          setState(() {});
        });
  }

  void navigateToSecondScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
            day: selectedDay,
            dropdownValue: dropdownValue,
            initFunction: initializePreviousScreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    // Define a list of food types based on the current day.

    // filterItemsFunction(selectedDay, dropdownValue);
    final foodTypes = <String>[
      'Veg',
      'NonVeg',
      'Diet',
      'Snacks',
    ];

    // dropdownValue = widget.foodType;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.amberAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white70,
                  ),
                  child: DropdownButton<String>(
                    value: selectedDay,
                    onChanged: (String? newValue) {
                      setState(() async {
                        selectedDay = newValue!;
                        await fetchMenuItems();
                      });
                    },
                    items: remainingDays
                        .map<DropdownMenuItem<String>>((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Center(
                            child: Text(day,
                                style: const TextStyle(fontSize: 23))),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.amberAccent,
                        width: 2.5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white70,
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    items:
                        foodTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                            child: Text(value,
                                style: const TextStyle(fontSize: 20))),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() async {
                        dropdownValue = newValue!;
                        await fetchMenuItems();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            (menuItems == null)
                ? const Center(child: Loader())
                : ListView.builder(
                    itemCount: menuItems!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final filteredItem = menuItems![index];
                      return Card(
                        elevation: 8,
                        shadowColor: const Color(0xff2da9ef),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          minLeadingWidth: 2,
                          leading: Container(
                            width: 2,
                            color: const Color(0xff2da9ef),
                          ),
                          title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                  child: Text(
                                filteredItem.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                              ))),
                          // subtitle: Text(
                          //   'Brother',
                          //   style: TextStyle(
                          //     color: Colors.blue.shade700,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          trailing: Visibility(
                            visible: (user.userType == 'user' ||
                                user.userType ==
                                    'super_admin'), // Change 'admin' to the actual userType condition
                            child: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      showMyDialog(
                                          filteredItem.name, filteredItem);
                                    },
                                    leading: const Icon(Icons.edit),
                                    title: const Text('Edit'),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () async {
                                      deleteMenuItem(filteredItem, index);

                                      Navigator.pop(context);
                                      //   ref.child(list[index]['id'].toString()).remove();
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ],
        ),
        floatingActionButton: Visibility(
          visible: (user.userType == 'user' || user.userType == 'super_admin'),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              onPressed: () {
                navigateToSecondScreen(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Future<void> showMyDialog(String title, MenuItem menuItem) async {
    TextEditingController editController = TextEditingController(text: title);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    menuServices.updateMenuItem(
                        context: context,
                        menuItem: menuItem,
                        name: editController.text,
                        onSuccess: () {
                          showSnackBar(
                              context, 'Menu Item Updated Succesfully!');
                          Navigator.pop(context);
                        });
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
