import 'dart:io';

import 'package:assessment/bloc/auth_bloc.dart';
import 'package:assessment/bloc/auth_event.dart';
import 'package:assessment/core/utils/navigator_service.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

import 'bloc/home_bloc.dart';
import 'models/home_model.dart';
import 'package:assessment/core/app_export.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(HomeState(homeModelObj: HomeModel()))
            ..add(HomeInitialEvent()),
      child: HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {







  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')


      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(" Video Call Screen"),
              onTap: () {
                NavigatorService.popAndPushNamed(AppRoutes.videoScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(" User List Screen"),
              onTap: () {
                NavigatorService.popAndPushNamed(AppRoutes.userScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                PrefUtils().setLoggedInUserId("");
                PrefUtils().setToken("");
                NavigatorService.popAndPushNamed(AppRoutes.loginPageScreen);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are logged in!', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              Text('Token:'),
              SelectableText(PrefUtils().getToken() ?? '— none —'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  PrefUtils().setLoggedInUserId("");
                  PrefUtils().setToken("");
                  NavigatorService.popAndPushNamed(AppRoutes.loginPageScreen);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
