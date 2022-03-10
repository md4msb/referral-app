import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:referral/repositories/user_repository.dart';
import 'package:referral/services/deep_link_service.dart';
import 'package:referral/view/widgets/bridge.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DeepLinkService.instance?.handleDynamicLinks();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UserRepository.instance.listenToCurrentAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Refferal App',
      home: Bridge(),
    );
  }
}
