import 'package:equatable/equatable.dart';

class CallState extends Equatable {
  final bool inCall;
  final bool muted;
  final bool videoEnabled;
  final bool screenSharing;
  final dynamic localStream; // MediaStream
  final dynamic remoteStream; // MediaStream
  final String? meetingId;

  const CallState({
    this.inCall = false,
    this.muted = false,
    this.videoEnabled = true,
    this.screenSharing = false,
    this.localStream,
    this.remoteStream,
    this.meetingId,
  });

  CallState copyWith({
    bool? inCall,
    bool? muted,
    bool? videoEnabled,
    bool? screenSharing,
    dynamic localStream,
    dynamic remoteStream,
    String? meetingId,
  }) {
    return CallState(
      inCall: inCall ?? this.inCall,
      muted: muted ?? this.muted,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      screenSharing: screenSharing ?? this.screenSharing,
      localStream: localStream ?? this.localStream,
      remoteStream: remoteStream ?? this.remoteStream,
      meetingId: meetingId ?? this.meetingId,
    );
  }

  @override
  List<Object?> get props => [inCall, muted, videoEnabled, screenSharing, localStream, remoteStream, meetingId];
}