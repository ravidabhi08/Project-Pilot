import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_pro/app.dart';
import 'package:taskflow_pro/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeApp();
  runApp(const TaskFlowApp());
  // hello sir
}
