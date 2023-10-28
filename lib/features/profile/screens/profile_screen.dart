import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('asset/person.png'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Vaibhav',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                user.psNumber.toString(),
                style: const TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    user.couponsLeft.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 40),
                  ),
                ),
              ),
              const Text(
                'Coupons Left',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    user.foodType,
                    style: const TextStyle(color: Colors.black, fontSize: 40),
                  ),
                ),
              ),
              const Text(
                'Food Type',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
