import 'package:csm_system/features/scan_qr/services/qr_scanner_services.dart';
import 'package:csm_system/models/qrmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/loader.dart';
import '../../../providers/user_provider.dart';

class ScannedUsersList extends StatefulWidget {
  static const String routeName = '/scanned-users';
  const ScannedUsersList({super.key});

  @override
  State<ScannedUsersList> createState() => _ScannedUsersListState();
}

class _ScannedUsersListState extends State<ScannedUsersList> {
  List<Qrmodel>? scannedUsers;
  List<Qrmodel>? filteredItems;
  final QrScannerServices adminServices = QrScannerServices();

  @override
  void initState() {
    super.initState();
    fetchAllScannedUsers();
  }

  fetchAllScannedUsers() async {
    scannedUsers = await adminServices.fetchAllScannedUsers(context);
    setState(() {});
  }

  filterItemsFunction(double scannedBy) async {
    setState(() {
      filteredItems = scannedUsers!.where((item) {
        return item.scannedBy == scannedBy;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    filterItemsFunction(user.psNumber);

    return scannedUsers == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 25),
              ),
            ),
            body: ListView.builder(
                itemCount: filteredItems!.length,
                itemBuilder: (context, index) {
                  final filteredUserData = filteredItems![index];
                  return Card(
                    color: Colors.amber.shade100,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Column(
                          children: [
                            Center(
                              child: Text(
                                filteredUserData.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Text(
                              'Total Users: ${filteredUserData.totalUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Veg Users: ${filteredUserData.vegUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Non-Veg Users: ${filteredUserData.nonVegUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Diet Users: ${filteredUserData.dietUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
