import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers (state management)
import 'package:cnetv_mobile_new/provider/user_provider.dart';
import 'package:cnetv_mobile_new/provider/ads_provider.dart';

// Screens
import 'screens/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AdsProvider>(create: (_) => AdsProvider()),
      ],
      child: const CnetvApp(),
    ),
  );
}

class CnetvApp extends StatelessWidget {
  const CnetvApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNETV Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainNavigation(),
    );
  }
}
