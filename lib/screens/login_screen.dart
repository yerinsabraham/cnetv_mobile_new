// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login controllers
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  bool _rememberMe = false;

  // Signup controllers
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    final reg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return reg.hasMatch(email.trim());
  }

  Future<void> _login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!_loginFormKey.currentState!.validate()) return;

    final email = _loginEmailController.text.trim();
    final pwd = _loginPasswordController.text;
    final success = await userProvider.login(email, pwd, rememberMe: _rememberMe);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  Future<void> _signup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!_signupFormKey.currentState!.validate()) return;

    final name = _signupNameController.text.trim();
    final email = _signupEmailController.text.trim();
    final pwd = _signupPasswordController.text;
    final success = await userProvider.signup(name, email, pwd);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed')),
      );
    }
  }

  void _continueAsGuest() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setGuestMode();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Login'),
                Tab(text: 'Sign Up'),
              ],
            ),

            // Body
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                _validateEmail(v) ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _loginPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v != null && v.length >= 6)
                                ? null
                                : 'Password min 6 chars',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed:
                                  userProvider.isLoading ? null : _login,
                              child: userProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _continueAsGuest,
                            child: const Text("Continue as Guest"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Signup Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _signupNameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                (v != null && v.trim().isNotEmpty)
                                    ? null
                                    : 'Enter name',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                _validateEmail(v) ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _signupPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v != null && v.length >= 6)
                                ? null
                                : 'Password min 6 chars',
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed:
                                  userProvider.isLoading ? null : _signup,
                              child: userProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Sign Up'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _continueAsGuest,
                            child: const Text("Continue as Guest"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
