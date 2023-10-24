import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../providers/user_provider.dart';

class QrScreen extends StatelessWidget {
  final List<dynamic> itemList;
  const QrScreen({super.key,required this.itemList});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String str1 = itemList.join(" ");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(now);

    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            'QR Page',
            style: TextStyle(fontSize: 25),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage('Assets/images/background_image.jpg'),
          //       fit: BoxFit.cover,
          //       opacity: 0.5
          //   ),
          // ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('asset/person.png'),
                radius: 70,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Generate the QR code using the QrImage widget from qr_flutter package
              Container(
                width: 350,
                height: 350,
                child: QrImageView(
                  data: str1,
                  version: QrVersions.auto,
                ),
              ),
              Text(
                '${itemList.elementAt(5)} Users',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
