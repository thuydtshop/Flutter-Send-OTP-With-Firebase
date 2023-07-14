import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send OTP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Send OTP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isSendingOtp = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isSendingOtp = true;
    });

    await auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Automatic handling of the SMS code on Android devices
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle failure events such as invalid phone numbers or whether the SMS quota has been exceeded

        // TODO: Handle other errors
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // resendToken is only supported on Android devices, iOS devices will always return a null value
        // Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code

        // Update the UI - wait for the user to enter the SMS code
        final smsCode = await showEnterCodeDialog(context);

        if (smsCode.isNotEmpty) {
          // Create a PhoneAuthCredential with the code
          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId, 
            smsCode: smsCode
          );

          // Sign the user in (or link) with the credential
          try {
            await auth.signInWithCredential(credential);

            // TODO: Handle success
            print('You have successfully signed in.');
          } on FirebaseAuthException catch (e) {
            print('The provided OTP is not valid.');
          }
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle a timeout of when automatic SMS code handling fails
      },
    );

    setState(() {
      _isSendingOtp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your phone number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'E.g. +84 123 456 789',
                ),
                keyboardType: TextInputType.phone,
                enabled: _isSendingOtp == false,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSendingOtp ? null : _sendOtp,
                child: Text(_isSendingOtp ? 'Sending...' : 'Send OTP'),
              ),
            ],
          )
        )
      )
    );
  }
}

Future<String> showEnterCodeDialog(BuildContext context) async {
  String code = '';

  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Your OTP:'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
          OutlinedButton(
            onPressed: () {
              code = '';
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
        content: Container(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) {
              code = value;
            },
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
      );
    }
  );

  return code;
}

