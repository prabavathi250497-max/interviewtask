import 'package:assessment/core/utils/navigator_service.dart';
import 'package:assessment/core/utils/pref_utils.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:assessment/bloc/auth_bloc.dart';
import 'package:assessment/bloc/auth_event.dart';
import 'package:assessment/bloc/call_bloc.dart';
import 'package:assessment/bloc/call_event.dart';
import 'package:assessment/bloc/call_state.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final String _meetingId = PrefUtils().getToken(); // hardcoded meeting ID
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initRenderers();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                    NavigatorService.popAndPushNamed(AppRoutes.userScreen);// handle logout or exit logic here

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
      appBar: AppBar(
          title: Row(
            children: [
              const Text('You are logged in!', style: TextStyle(fontSize: 20)),
            ],
          ),
        actions: [

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<CallBloc, CallState>(
                listener: (context, state) async {
                  // update renderers when streams change
                  if (state.localStream != null) {
                    _localRenderer.srcObject = state.localStream;
                  }
                  if (state.remoteStream != null) {
                    _remoteRenderer.srcObject = state.remoteStream;
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Colors.black87,
                          child: state.remoteStream != null
                              ? RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                              : const Center(child: Text('Waiting for remote participant...', style: TextStyle(color: Colors.white))),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        width: 140,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
                          child: state.localStream != null
                              ? RTCVideoView(_localRenderer, mirror: true)
                              : const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            _controlBar(),
            const SizedBox(height: 8),
            _joinButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _controlBar() {
    return BlocBuilder<CallBloc, CallState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'mic',
            onPressed: () => context.read<CallBloc>().add(ToggleMute()),
            child: Icon(state.muted ? Icons.mic_off : Icons.mic),
          ),
          FloatingActionButton(
            heroTag: 'video',
            onPressed: () => context.read<CallBloc>().add(ToggleVideo()),
            child: Icon(state.videoEnabled ? Icons.videocam : Icons.videocam_off),
          ),
          FloatingActionButton(
            heroTag: 'screen',
            onPressed: () => context.read<CallBloc>().add(ToggleScreenShare()),
            child: Icon(state.screenSharing ? Icons.stop_screen_share : Icons.screen_share),
          ),
          FloatingActionButton(
            heroTag: 'hangup',
            backgroundColor: Colors.red,
            onPressed: () => context.read<CallBloc>().add(HangUp()),
            child: const Icon(Icons.call_end),
          ),
        ],
      );
    });
  }

  Widget _joinButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<CallBloc>().add(JoinCall(_meetingId));
          },
          child: const Text('Join / Create Meeting'),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            // update renderers from Bloc state (helpful when user joins)
            final state = context.read<CallBloc>().state;
            if (state.localStream != null) _localRenderer.srcObject = state.localStream;
            if (state.remoteStream != null) _remoteRenderer.srcObject = state.remoteStream;
          },
          child: const Text('Refresh Views'),
        ),
      ],
    );
  }
}