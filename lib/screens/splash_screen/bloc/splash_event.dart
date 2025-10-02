// ignore_for_file: must_be_immutable

part of 'splash_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Pgcommercial widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class SplashEvent extends Equatable {}

/// Event that is dispatched when the Pgcommercial widget is first created.
class SplashInitialEvent extends SplashEvent {
  @override
  List<Object?> get props => [];
}
