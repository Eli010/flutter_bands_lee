import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:band_names_app/src/common/services/socket_service.dart';

import 'package:band_names_app/src/presentation/page/home_page.dart';
import 'package:band_names_app/src/presentation/page/status_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'status': (context) => const StatusPage()
        },
      ),
    );
  }
}
