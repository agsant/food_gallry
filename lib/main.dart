import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsan/bloc_events/foods_bloc_state.dart';
import 'package:foodsan/services/api_service.dart';
import 'package:foodsan/views/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foods Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => FoodsBloc(apiService: ApiService()),
        child: HomeScreen(),
      ),
    );
  }
}
