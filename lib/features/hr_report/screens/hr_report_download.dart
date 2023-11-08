import 'package:csm_system/features/hr_report/services/hr_services.dart';
import 'package:csm_system/features/hr_report/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class HrReportDownload extends StatefulWidget {
  const HrReportDownload({super.key});

  @override
  State<HrReportDownload> createState() => _HrReportDownloadState();
}

class _HrReportDownloadState extends State<HrReportDownload> {
  DateTime selectedDate1 = DateTime.now();

  DateTime selectedDate2 = DateTime.now();

  final HrSevices hrServices = HrSevices();

  void sendReportToHr(String email) async {
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(selectedDate1);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(selectedDate2);

    hrServices.sendReportToHr(
        context: context,
        date1: formattedDate1,
        date2: formattedDate2,
        email: email,
        onSuccess: () {
          showSnackBar(context, 'Sent Report to your Email!');
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Report'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'From',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            DatePickerExample(
              selectedDate: selectedDate1,
              onDateSelected: (newDate) {
                setState(() {
                  selectedDate1 = newDate; // Update selectedDate1
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'To',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            DatePickerExample(
              selectedDate: selectedDate2,
              onDateSelected: (newDate) {
                setState(() {
                  selectedDate2 = newDate; // Update selectedDate1
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                height: 40,
                width: 200,
                child: ElevatedButton(
                    onPressed: () async {
                      sendReportToHr(user.email);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(fontSize: 30),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
