import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assessment/data/repository/signaling_repository.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final SignalingRepository signalingRepository;
  StreamSubscription? _remoteStreamSub;

  CallBloc({required this.signalingRepository}) : super(const CallState()) {
    on<JoinCall>(_onJoinCall);
    on<ToggleMute>(_onToggleMute);
    on<ToggleVideo>(_onToggleVideo);
    on<ToggleScreenShare>(_onToggleScreenShare);
    on<HangUp>(_onHangUp);
    //on<_LocalStreamReady>(_onLocalStreamReady);
    on<LocalStreamReady>(_onLocalStreamReady);
   // on<RemoteStreamAdded>(_onRemoteStreamAdded);
    on<RemoteStreamAdded>(_onRemoteStreamAdded);
  }

  Future<void> _onJoinCall(JoinCall event, Emitter<CallState> emit) async {
    final meetingId = event.meetingId;
    // 1) create local stream
    final localStream = await signalingRepository.initLocalStream();
    add(LocalStreamReady(localStream));

    // 2) join or create room (signaling) and get remote stream updates via callback
    await signalingRepository.joinRoom(
      meetingId,
      localStream,
      onRemoteStream: (remote) {
        add(RemoteStreamAdded(remote));
      },
    );

    emit(state.copyWith(inCall: true, meetingId: meetingId));
  }

  void _onLocalStreamReady(
      LocalStreamReady event,
      Emitter<CallState> emit,
      ) {
    emit(state.copyWith(localStream: event.stream));
  }

   _onRemoteStreamAdded(
      RemoteStreamAdded event,
      Emitter<CallState> emit,
      ) {
     emit(state.copyWith(remoteStream: event.remoteStream));
  }

  // void _onRemoteStreamAdded(_RemoteStreamAdded event, Emitter<CallState> emit) {
  //   emit(state.copyWith(remoteStream: event.stream));
  // }

  Future<void> _onToggleMute(ToggleMute event, Emitter<CallState> emit) async {
    final muted = !state.muted;
    signalingRepository.setMicrophoneEnabled(!muted);
    emit(state.copyWith(muted: muted));
  }

  Future<void> _onToggleVideo(ToggleVideo event, Emitter<CallState> emit) async {
    final enabled = !state.videoEnabled;
    await signalingRepository.setCameraEnabled(enabled);
    // update local stream reference in state
    final local = signalingRepository.localStream;
    emit(state.copyWith(videoEnabled: enabled, localStream: local));
  }

  Future<void> _onToggleScreenShare(ToggleScreenShare event, Emitter<CallState> emit) async {
    final isSharing = !state.screenSharing;
    if (isSharing) {
      await signalingRepository.startScreenShare();
    } else {
      await signalingRepository.stopScreenShare();
    }
    emit(state.copyWith(screenSharing: isSharing, localStream: signalingRepository.localStream));
  }

  Future<void> _onHangUp(HangUp event, Emitter<CallState> emit) async {
    await signalingRepository.hangUp(state.meetingId);
    emit(const CallState());
  }

  @override
  Future<void> close() {
    _remoteStreamSub?.cancel();
    signalingRepository.dispose();
    return super.close();
  }
}