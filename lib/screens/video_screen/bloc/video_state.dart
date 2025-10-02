// ignore_for_file: must_be_immutable

part of 'video_bloc.dart';

/// Represents the state of Pgcommercial in the application.
class VideoState extends Equatable {
  VideoState({this.videoModelObj});

  VideoModel? videoModelObj;

  @override
  List<Object?> get props => [videoModelObj];
  VideoState copyWith({VideoModel? videoModelObj}) {
    return VideoState(videoModelObj: videoModelObj ?? this.videoModelObj);
  }
}
