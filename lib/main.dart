import 'package:flutter/material.dart';
import 'common/global.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  authToken = await storage.read(key: "token");
  runApp(MyApp(authToken));
}



