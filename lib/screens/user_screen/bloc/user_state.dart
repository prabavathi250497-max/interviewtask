// ignore_for_file: must_be_immutable

part of 'user_bloc.dart';

/// Represents the state of Pgcommercial in the application.
class UserState extends Equatable {
  UserState({this.userModelObj});

  UserModel? userModelObj;

  @override
  List<Object?> get props => [userModelObj];
  UserState copyWith({UserModel? userModelObj}) {
    return UserState(userModelObj: userModelObj ?? this.userModelObj);
  }
}
