import 'package:csm_system/features/scan_qr/services/qr_scanner_services.dart';
import 'package:csm_system/models/qrmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/loader.dart';
import '../../../providers/user_provider.dart';
import '../../generate_qr/services/check_snacks_time.dart';

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
  final CheckSnacksTime checkSnacksTime = CheckSnacksTime();
  late bool isSnacksTime = false;

  @override
  void initState() {
    super.initState();
    isSnacksTime = checkSnacksTime.checkSnacksTime();
  }

  fetchAllScannedUsers(int psNumber) async {
    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    scannedUsers = await adminServices.fetchAllScannedUsers(
        context, psNumber, formatter.toString());
    setState(() {});
  }

  fetchAllSnacksScannedUsers(int psNumber) async {
    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    scannedUsers = await adminServices.fetchAllSnacksScannedUsers(
        context, psNumber, formatter.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (isSnacksTime) {
      fetchAllSnacksScannedUsers(user.psNumber);
    } else {
      fetchAllScannedUsers(user.psNumber);
    }

    return scannedUsers == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Scanned Users',
                style: TextStyle(fontSize: 25),
              ),
            ),
            body: ListView.builder(
                itemCount: scannedUsers!.length,
                itemBuilder: (context, index) {
                  final filteredUserData = scannedUsers![index];
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
                            if(!isSnacksTime)Text(
                              'Total Users: ${filteredUserData.totalUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            if(!isSnacksTime) Text(
                              'Veg Users: ${filteredUserData.vegUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            if(!isSnacksTime)Text(
                              'Non-Veg Users: ${filteredUserData.nonVegUsers}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            if(!isSnacksTime) Text(
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
