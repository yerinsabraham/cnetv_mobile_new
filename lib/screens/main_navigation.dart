import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/live_tv_screen.dart';
import '../screens/chat_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _allScreens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _allScreens.addAll([
      const HomeScreen(),
      const LiveTvScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ]);
  }

  void _onTabTapped(int index, bool isLoggedIn) {
    // Prevent unauthenticated users from accessing protected screens
    if (!isLoggedIn && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to access this feature")),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Show login screen if not logged in
    if (!userProvider.isLoading && !userProvider.isLoggedIn) {
      return const LoginScreen();
    }

    // While loading user data, show spinner
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _allScreens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onTabTapped(index, userProvider.isLoggedIn),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: "Live TV",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
