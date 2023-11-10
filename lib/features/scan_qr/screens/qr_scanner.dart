import 'dart:convert';
import 'package:csm_system/common/widgets/custom_button.dart';
import 'package:csm_system/features/scan_qr/screens/snacks_result.dart';
import 'package:csm_system/features/scan_qr/services/qr_scanner_services.dart';
import 'package:csm_system/features/scan_qr/services/snacks_qr_scanner.dart';
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
  late bool isSnacksTime = false;
  MobileScannerController controller = MobileScannerController();
  final QrScannerServices qrscannerServices = QrScannerServices();
  final SnacksQrScannerServices snacksQrScannerServices =
      SnacksQrScannerServices();

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  void initState() {
    super.initState();
    checkSnacksTime();
  }

  Future<void> addUserInList(String data, int scannedBy, String date1) async {
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

  Future<bool> deductCoupons(int psNumber, int totalUsers) async {
    Future<bool> result = qrscannerServices.deductCoupons(
        context: context, psNumber: psNumber, totalUsers: totalUsers);

    return result;
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

  Future<bool> snacksScannedUser(int psNumber, String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse('$uri/snacks/check-scanned-user'),
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

  Future<void> addUserInSnacksList(
      String data, int scannedBy, String date1) async {
    List<String> code = data.split(" ");

    // print("personname ${code[0].toString()}");

    snacksQrScannerServices.addToSnacksList(
      context: context,
      name: code[0].toString(),
      psNumber: int.parse(code[2].toString()),
      scannedBy: scannedBy,
      date: date1,
    );
  }

  void checkSnacksTime() {
    DateTime now = DateTime.now();

    // Define the target time range
    TimeOfDay startTime = const TimeOfDay(hour: 15, minute: 0); // 3:00 PM
    TimeOfDay endTime = const TimeOfDay(hour: 19, minute: 0); // 7:00 PM

    // Convert the current time and target times to Duration for comparison
    Duration currentTime = Duration(hours: now.hour, minutes: now.minute);
    Duration startDuration =
        Duration(hours: startTime.hour, minutes: startTime.minute);
    Duration endDuration =
        Duration(hours: endTime.hour, minutes: endTime.minute);

    // Check if the current time is within the target range
    isSnacksTime = currentTime >= startDuration && currentTime <= endDuration;
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

                        final now = DateTime.now();
                        String formatter = DateFormat('yMd').format(now);

                        if (isSnacksTime) {
                          bool userScannedorNot = await snacksScannedUser(
                              int.parse(code1[2].toString()), formatter);

                          // if (sufficientCoupons && !alreadyScanned) {
                          if (userScannedorNot) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoSufficientCoupons(
                                          closeScreen: closeScreen,
                                        )));
                          } else {
                            await addUserInSnacksList(
                                code, user.psNumber, formatter);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SnacksResult(
                                          closeScreen: closeScreen,
                                          code: code,
                                        )));
                          }
                        } else {
                          bool userScannedorNot = await checkUser(
                              int.parse(code1[2].toString()), formatter);

                          // if (sufficientCoupons && !alreadyScanned) {
                          if (userScannedorNot) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoSufficientCoupons(
                                          closeScreen: closeScreen,
                                        )));
                          } else {
                            bool result = await deductCoupons(
                                int.parse(code1[2].toString()),
                                int.parse(code1[6].toString()));

                            if (result) {
                              await addUserInList(
                                  code, user.psNumber, formatter);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultScreen(
                                            closeScreen: closeScreen,
                                            code: code,
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoSufficientCoupons(
                                            closeScreen: closeScreen,
                                          )));
                            }
                          }
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
            const SizedBox(
              height: 10,
            ),
            isSnacksTime
                ? Container()
                : CustomButton(
                    text: 'Proceed',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScannedUsersList(),
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
