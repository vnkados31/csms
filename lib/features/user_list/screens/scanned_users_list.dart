import 'package:csm_system/features/scan_qr/services/qr_scanner_services.dart';
import 'package:csm_system/models/qrmodel.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/loader.dart';

class ScannedUsersList extends StatefulWidget {
  static const String routeName = '/scanned-users';
  const ScannedUsersList({super.key});

  @override
  State<ScannedUsersList> createState() => _ScannedUsersListState();
}

class _ScannedUsersListState extends State<ScannedUsersList> {
  List<Qrmodel>? scannedUsers;
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

  @override
  Widget build(BuildContext context) {
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
                itemCount: scannedUsers!.length,
                itemBuilder: (context, index) {
                  final scannedUserData = scannedUsers![index];
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
                                scannedUserData.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Text(
                              'Total Users: ${scannedUserData.totalUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Veg Users: ${scannedUserData.totalUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Non-Veg Users: ${scannedUserData.nonVegUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Diet Users: ${scannedUserData.dietUsers}',
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
