import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:equatable/equatable.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

class HangUp extends CallEvent {}

class LocalStreamReady extends CallEvent {
  final MediaStream stream;
  const LocalStreamReady(this.stream);

  @override
  List<Object?> get props => [stream];
}

// class RemoteStreamAdded extends CallEvent {
//   final MediaStream stream;
//   const RemoteStreamAdded(this.stream);
//
//   @override
//   List<Object?> get props => [stream];
// }

class RemoteStreamAdded extends CallEvent {
  final MediaStream remoteStream;
  const RemoteStreamAdded(this.remoteStream);

  @override
  List<Object?> get props => [remoteStream];
}
class JoinCall extends CallEvent {
  final String meetingId;
  const JoinCall(this.meetingId);
  @override
  List<Object?> get props => [meetingId];
}

class ToggleMute extends CallEvent {}
class ToggleVideo extends CallEvent {}
class ToggleScreenShare extends CallEvent {}
