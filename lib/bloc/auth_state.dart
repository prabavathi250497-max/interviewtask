import 'package:equatable/equatable.dart';


abstract class AuthState extends Equatable {
  const AuthState();


  @override
  List<Object?> get props => [];
}


class AuthUnauthenticated extends AuthState {}


class AuthLoading extends AuthState {}


class AuthAuthenticated extends AuthState {
  final String token;
  const AuthAuthenticated({required this.token});


  @override
  List<Object?> get props => [token];
}


class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});


  @override
  List<Object?> get props => [message];
}