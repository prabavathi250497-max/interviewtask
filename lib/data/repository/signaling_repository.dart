import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class SignalingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RTCPeerConnection? _peerConnection;
  MediaStream? localStream;
  MediaStream? _displayStream;
  MediaStream? remoteStream;
  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ]
  };

  // initialize camera/mic
  Future<MediaStream> initLocalStream({bool video = true, bool audio = true}) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': audio,
      'video': video
          ? {
        'facingMode': 'user',
        'width': {'ideal': 1280},
        'height': {'ideal': 720},
      }
          : false,
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return localStream!;
  }

  Future<void> joinRoom(String roomId, MediaStream local, {required void Function(MediaStream) onRemoteStream}) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();

    _peerConnection = await createPeerConnection(_iceServers);

    // add local stream tracks
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteStream = event.streams[0];
        onRemoteStream(remoteStream!);
      }
    };

    // attach local tracks
    for (var track in local.getTracks()) {
      _peerConnection!.addTrack(track, local);
    }

    // ICE candidate -> add to firestore
    final callerCandidatesCollection = roomRef.collection('callerCandidates');
    final calleeCandidatesCollection = roomRef.collection('calleeCandidates');

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        final data = {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        };
        // if creator (room didn't exist) we will write to callerCandidates
        // But since we don't know role here, determine by room existence
        if (!roomSnapshot.exists) {
          callerCandidatesCollection.add(data);
        } else {
          calleeCandidatesCollection.add(data);
        }
      }
    };

    if (!roomSnapshot.exists) {
      // create room (offer)
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      final roomWithOffer = {
        'offer': {'type': offer.type, 'sdp': offer.sdp},
      };
      await roomRef.set(roomWithOffer);

      // listen for answer
      roomRef.snapshots().listen((snapshot) async {
        final data = snapshot.data();
        if (data != null && data['answer'] != null) {
          final answer = data['answer'];
          final remoteDesc = RTCSessionDescription(answer['sdp'], answer['type']);
          await _peerConnection!.setRemoteDescription(remoteDesc);
        }
      });

      // listen for callee ICE candidates
      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        for (var doc in snapshot.docChanges) {
          if (doc.type == DocumentChangeType.added) {
            final data = doc.doc.data();
            if (data != null) {
              final candidate = RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
              _peerConnection!.addCandidate(candidate);
            }
          }
        }
      });
    } else {
      // join existing room (answer)
      final roomData = roomSnapshot.data()!;
      final offer = roomData['offer'];
      final offerDesc = RTCSessionDescription(offer['sdp'], offer['type']);
      await _peerConnection!.setRemoteDescription(offerDesc);

      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      await roomRef.update({'answer': {'type': answer.type, 'sdp': answer.sdp}});

      // listen for caller ICE candidates
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var doc in snapshot.docChanges) {
          if (doc.type == DocumentChangeType.added) {
            final data = doc.doc.data();
            if (data != null) {
              final candidate = RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
              _peerConnection!.addCandidate(candidate);
            }
          }
        }
      });

      // add local onIceCandidate to calleeCandidates
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate.candidate != null) {
          final data = {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          };
          calleeCandidatesCollection.add(data);
        }
      };
    }
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    if (localStream == null) return;
    for (var track in localStream!.getAudioTracks()) {
      track.enabled = enabled;
    }
  }

  Future<void> setCameraEnabled(bool enabled) async {
    if (localStream == null) return;
    for (var track in localStream!.getVideoTracks()) {
      track.enabled = enabled;
    }
  }

  Future<void> startScreenShare() async {
    try {
      // Attempt getDisplayMedia (works on Web and Android if supported)
      _displayStream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{'video': true, 'audio': true});
      if (_displayStream != null && _peerConnection != null) {
        final videoTrack = _displayStream!.getVideoTracks().first;
        // find sender
      //  final senders = _peerConnection!.getSenders();
        RTCRtpSender? videoSender;
        final senders = await _peerConnection!.getSenders(); // now it's List<RTCRtpSender>
        for (var s in senders) {
          if (s.track != null && s.track!.kind == 'video') {
            videoSender = s;
            break;
          }
        }
        if (videoSender != null) {
          await videoSender.replaceTrack(videoTrack);
        }
        // update localStream reference for UI if needed
        localStream = _displayStream;
      }
    } catch (e) {
      print('Screen share failed: $e');
    }
  }

  Future<void> stopScreenShare() async {
    if (_displayStream != null) {
      // switch back to camera
      final cameraStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
      localStream = cameraStream;
      final videoTrack = cameraStream.getVideoTracks().first;
      //final senders = _peerConnection!.getSenders();
      RTCRtpSender? videoSender;
      final senders = await _peerConnection!.getSenders(); // now it's List<RTCRtpSender>
      for (var s in senders) {
        if (s.track != null && s.track!.kind == 'video') {
          videoSender = s;
          break;
        }
      }
      if (videoSender != null) {
        await videoSender.replaceTrack(videoTrack);
      }
      // stop and cleanup display tracks
      _displayStream!.getTracks().forEach((t) => t.stop());
      _displayStream = null;
    }
  }

  Future<void> hangUp(String? roomId) async {
    try {
      if (_peerConnection != null) {
        await _peerConnection!.close();
        _peerConnection = null;
      }
      if (localStream != null) {
        localStream!.getTracks().forEach((t) => t.stop());
        localStream = null;
      }
      if (roomId != null) {
        final roomRef = _firestore.collection('rooms').doc(roomId);
        final callerCandidates = await roomRef.collection('callerCandidates').get();
        for (var doc in callerCandidates.docs) {
          await doc.reference.delete();
        }
        final calleeCandidates = await roomRef.collection('calleeCandidates').get();
        for (var doc in calleeCandidates.docs) {
          await doc.reference.delete();
        }
        final roomSnapshot = await roomRef.get();
        if (roomSnapshot.exists) {
          await roomRef.delete();
        }
      }
    } catch (e) {
      print('Hangup error: $e');
    }
  }

  void dispose() {
    if (_peerConnection != null) {
      _peerConnection!.close();
      _peerConnection = null;
    }
    if (localStream != null) {
      localStream!.getTracks().forEach((t) => t.stop());
      localStream = null;
    }
  }
}