import 'dart:io';

import 'package:geolocator/geolocator.dart';

import 'bloc/splash_bloc.dart';
import 'models/splash_model.dart';
import 'package:assessment/core/app_export.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) =>
          SplashBloc(SplashState(splashModelObj: SplashModel()))
            ..add(SplashInitialEvent()),
      child: SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _visible = false;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      "assets/images/splash/splash.mp4",
    );

    /*_controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));*/
    _controller.initialize().then((_) {
      _controller.setLooping(false);
      setState(() {
        _controller.play();
        _visible = true;
      });
    });
  }





  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Action 1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Action 2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: SizedBox.expand(
            child: FittedBox(
              // If your background video doesn't look right, try changing the BoxFit property.
              // BoxFit.fill created the look I was going for.
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
          ),
        );
      },
    );
  }
}
