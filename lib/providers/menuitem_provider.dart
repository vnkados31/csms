
// import 'package:csm_system/features/menu/services/menu_services.dart';
// import 'package:flutter/material.dart';

// import '../models/menuitem.dart';

// class MenuItemsProvider extends ChangeNotifier {

//   final BuildContext context;
//   final _service = MenuServices();

//   MenuItemsProvider(this.context);

   
//   bool isLoading = false;
//   List<MenuItem> _menuItems = [];


  
//   List<MenuItem> get menuItems => _menuItems;


//   Future<void> getAllTodos() async {
//     isLoading = true;
//     notifyListeners();

//    // final response = await _service.fetchMenuItems(context);

//     _menuItems = response;
//     isLoading = false;
//     notifyListeners();
//   }
// }