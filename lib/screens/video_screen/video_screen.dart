import 'dart:io';

import 'package:assessment/bloc/auth_bloc.dart';
import 'package:assessment/bloc/auth_event.dart';
import 'package:assessment/bloc/call_bloc.dart';
import 'package:assessment/core/utils/navigator_service.dart';
import 'package:assessment/data/repository/signaling_repository.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/video_screen/video_call_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'bloc/video_bloc.dart';
import 'models/video_model.dart';
import 'package:assessment/core/app_export.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<VideoBloc>(
      create: (context) =>
          VideoBloc(VideoState(videoModelObj: VideoModel()))
            ..add(VideoInitialEvent()),
      child: VideoScreen(),
    );
  }

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _visible = false;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      "assets/images/video/video.mp4",
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
        title: 'One-to-One Video Call (WebRTC)',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const VideoCallScreen(),
      ),
    );
  }
}
