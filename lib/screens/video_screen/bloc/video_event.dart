// ignore_for_file: must_be_immutable

part of 'video_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Pgcommercial widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class VideoEvent extends Equatable {}

/// Event that is dispatched when the Pgcommercial widget is first created.
class VideoInitialEvent extends VideoEvent {
  @override
  List<Object?> get props => [];
}
