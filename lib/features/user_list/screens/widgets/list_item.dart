import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String name;
  final double totalUsers;
  final double vegUsers;
  final double nonVegUsers;
  final double dietUsers;

  const ListItem({
    Key? key,
    required this.name,
    required this.totalUsers,
    required this.vegUsers,
    required this.nonVegUsers,
    required this.dietUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          color: Colors.amber.shade100,
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Column(
                children: [
                  Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text(
                    'Total Users: $totalUsers',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Veg Users: $vegUsers',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Non Users: $nonVegUsers',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Diet Users: $dietUsers',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
