import 'dart:io';

import 'package:assessment/bloc/auth_bloc.dart';
import 'package:assessment/bloc/auth_event.dart';
import 'package:assessment/bloc/call_bloc.dart';
import 'package:assessment/core/utils/navigator_service.dart';
import 'package:assessment/data/repository/signaling_repository.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/User/user_list_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'bloc/user_bloc.dart';
import 'models/user_model.dart';
import 'package:assessment/core/app_export.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) =>
          UserBloc(UserState(userModelObj: UserModel()))
            ..add(UserInitialEvent()),
      child: UserScreen(),
    );
  }

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {






  @override
  @override
  Widget build(BuildContext context) {
    final signalingRepo = SignalingRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CallBloc(signalingRepository: signalingRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'One-to-One User Call (WebRTC)',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const UserListScreen(),
      ),
    );
  }
}
