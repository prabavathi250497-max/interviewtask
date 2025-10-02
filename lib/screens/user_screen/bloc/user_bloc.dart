import 'package:assessment/core/utils/navigator_service.dart' show NavigatorService;
import 'package:assessment/core/utils/pref_utils.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/user_screen/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_event.dart';
part 'user_state.dart';

/// A bloc that manages the state of a Pgcommercial according to the event that is dispatched to it.
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(initialState) {
    on<UserInitialEvent>(_onInitialize);
  }

  _onInitialize(UserInitialEvent event, Emitter<UserState> emit) async {

  }
}
