import 'package:csm_system/common/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/widgets/bottom_bar.dart';
import 'constants/global_variables.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'providers/user_provider.dart';
import 'router.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  // This widget is the root of your application.

  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    await authService.getUserData(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSM System',
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme:
              const ColorScheme.light(primary: GlobalVariables.secondaryColor),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ))),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: isLoading
          ? const Loader() // Show loading indicator while data is loading
          : Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? const BottomBar()
              : const AuthScreen(),
    );
  }
}
