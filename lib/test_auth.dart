import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');
  } catch (e) {
    print('❌ Firebase init failed: $e');
  }

  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String status = 'Ready';
  User? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() {
    currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      status = currentUser == null 
        ? 'Not logged in' 
        : 'Logged in as: ${currentUser!.email}';
    });
  }

  Future<void> testLogin() async {
    setState(() {
      isLoading = true;
      status = 'Logging in...';
    });

    try {
      print('🔐 Testing login with: ${emailCtrl.text}');
      
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passCtrl.text,
      );
      
      print('✅ Login successful: ${result.user?.email}');
      
      setState(() {
        currentUser = result.user;
        status = 'Logged in: ${result.user?.email}';
      });
    } catch (e) {
      print('❌ Login failed: $e');
      setState(() {
        status = 'Login failed: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> testLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        currentUser = null;
        status = 'Logged out';
      });
    } catch (e) {
      setState(() => status = 'Logout failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Auth Test')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(status),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email field
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),

              // Password field
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : testLogin,
                  child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Test Login'),
                ),
              ),
              const SizedBox(height: 12),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: testLogout,
                  child: const Text('Test Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
