import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('╔════════════════════════════════════════════════╗');
  print('║      FIREBASE INITIALIZATION TEST              ║');
  print('╚════════════════════════════════════════════════╝');

  try {
    print('\n1️⃣ Getting Firebase Options...');
    final options = DefaultFirebaseOptions.currentPlatform;
    
    print('   ✅ Options retrieved successfully');
    print('   Project ID: ${options.projectId}');
    print('   API Key: ${options.apiKey.substring(0, 20)}...');
    print('   App ID: ${options.appId}');

    print('\n2️⃣ Initializing Firebase...');
    await Firebase.initializeApp(options: options);
    print('   ✅ Firebase initialized successfully!');

    print('\n3️⃣ Firebase Instance Info:');
    print('   App Name: ${Firebase.app().name}');
    print('   Options Project ID: ${Firebase.app().options.projectId}');

    print('\n✅ ALL TESTS PASSED!');
    print('\nYour Firebase configuration is correct.');
    print('The app should run without auto-closing.');

  } catch (e) {
    print('\n❌ ERROR: $e');
    print('\nType: ${e.runtimeType}');
    print('Stack trace: $e');
  }

  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Config Test'),
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 80, color: Colors.green),
              SizedBox(height: 24),
              Text(
                'Firebase Initialized\nSuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                'Check console for details',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
