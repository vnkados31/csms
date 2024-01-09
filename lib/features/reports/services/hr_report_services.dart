// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../../constants/error_handling.dart';
// import '../../../constants/global_variables.dart';
// import '../../../constants/utils.dart';
// import '../../../providers/user_provider.dart';

// void sendReportToHr({
//   required BuildContext context,
//   required String date1,
//   required String date2,
//   required String email,
//   required VoidCallback onSuccess,
// }) async {
//   try {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     http.Response res = await http.post(
//       Uri.parse('$uri/hr/generate-report-as-json'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'x-auth-token': userProvider.user.token,
//       },
//       body: jsonEncode({'date1': date1, 'date2': date2, 'email': email}),
//     );

//     // Handle errors and success
//     httpErrorHandle(
//       response: res,
//       context: context,
//       onSuccess: () {
//         // Trigger the download function on success
//         downloadExcelFileFromJson(res.body);
//         onSuccess();
//       },
//     );
//   } catch (e) {
//     showSnackBar(context, e.toString());
//   }
// }

// void downloadExcelFileFromJson(String jsonData) async {
//   // Parse JSON data
//   List<Map<String, dynamic>> data = json.decode(jsonData);

//   // Create an Excel workbook
//   final excel = Excel.createExcel();

//   // Add a sheet to the workbook
//   final sheet = excel['Sheet1'];

//   // Add headers to the sheet
//   sheet.appendRow([
//     ('psNumber'),
//     StringValue('Date'),
//     StringValue('couponsBookCount'),
//   ]);

//   // Add data to the sheet
//   for (var entry in data) {
//     sheet.appendRow([
//       StringValue(entry['psNumber'].toString()),
//       StringValue(entry['date'].toString()),
//       StringValue(entry['couponsBookCount'].toString()),
//     ]);
//   }

//   // Save the Excel file
//   final List<int>? excelBytes = await excel.encode();

//   // Convert List<int> to Uint8List
//   final Uint8List uint8List = Uint8List.fromList(excelBytes!);

//   // Save the Excel file to a temporary directory
//   final directory = await getTemporaryDirectory();
//   final filePath = '${directory.path}/CouponsBookData.xlsx';

//   await File(filePath).writeAsBytes(uint8List);

//   // Open the file using a file explorer or any method suitable for your platform
//   // Here, we print the file path for demonstration purposes
//   print('Excel file saved to: $filePath');
// }