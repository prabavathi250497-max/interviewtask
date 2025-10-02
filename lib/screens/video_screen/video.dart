
import 'package:assessment/screens/video_screen/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:assessment/bloc/call_bloc.dart';
import 'package:assessment/core/app_export.dart';
import 'package:assessment/data/repository/signaling_repository.dart';

class Video extends StatelessWidget {
  const Video({super.key});

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