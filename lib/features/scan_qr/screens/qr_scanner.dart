import 'dart:convert';

import 'package:csm_system/features/scan_qr/services/qr_scanner_services.dart';
import 'package:csm_system/features/user_list/screens/scanned_users_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
// import 'no_sufficient_coupons.dart';
import 'no_sufficient_coupons.dart';
import 'result_screen.dart';

class QrScanner extends StatefulWidget {
  static const String routeName = '/qrscreen';
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late bool sufficientCoupons = true;

  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  MobileScannerController controller = MobileScannerController();
  final QrScannerServices qrscannerServices = QrScannerServices();

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> addUserInList(
      String data, int scannedBy, String date1) async {
    List<String> code = data.split(" ");

    qrscannerServices.addToList(
        context: context,
        name: code[0].toString(),
        email: code[1].toString(),
        psNumber: int.parse(code[2].toString()),
        vegUsers: int.parse(code[3].toString()),
        nonVegUsers: int.parse(code[4].toString()),
        dietUsers: int.parse(code[5].toString()),
        totalUsers: int.parse(code[6].toString()),
        scannedBy: scannedBy,
        couponsLeft: int.parse(code[7].toString()),
        date: date1);
  }

  // Replace with the user's date

  Future<bool> checkUser(int psNumber, String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse('$uri/admin/check-scanned-user'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({'psNumber': psNumber, 'date': date}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["found"] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      showSnackBar(context, '${response.statusCode}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                controller.toggleTorch();
              },
              icon: Icon(
                Icons.flash_on,
                color: isFlashOn ? Colors.blue : Colors.grey,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  isFrontCamera = !isFrontCamera;
                });
                controller.switchCamera();
              },
              icon: Icon(
                Icons.camera_front,
                color: isFrontCamera ? Colors.blue : Colors.grey,
              ))
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      "Place you Qr Code in the area",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Scanning will be started automatically",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    )
                  ],
                )),
            Expanded(
              flex: 7,
              child: Container(
                  child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    allowDuplicates: true,
                    onDetect: (barcode, args) async {
                      if (!isScanCompleted) {
                        String code = barcode.rawValue ?? '...';
                        List<String> code1 = code.split(" ");
                        isScanCompleted = true;

                        final now = new DateTime.now();
                        String formatter = DateFormat('yMd').format(now);

                        bool userScannedorNot = await checkUser(
                            int.parse(code1[2].toString()), formatter);

                        // if (sufficientCoupons && !alreadyScanned) {
                        if (userScannedorNot ||
                            int.parse(code1[6].toString()) >
                                int.parse(code1[7].toString())) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoSufficientCoupons(
                                        closeScreen: closeScreen,
                                      )));
                        } else {
                          await addUserInList(code, user.psNumber, formatter);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        closeScreen: closeScreen,
                                        code: code,
                                      )));
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.grey.withOpacity(0.5),
                    borderColor: Colors.blue,
                  )
                ],
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // String currentUserUid = _user!.uid;
                  // //print(currentUserUid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScannedUsersList(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
