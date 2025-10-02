import 'package:assessment/core/utils/navigator_service.dart' show NavigatorService;
import 'package:assessment/core/utils/pref_utils.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/home_screen/models/home_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

/// A bloc that manages the state of a Pgcommercial according to the event that is dispatched to it.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState) {
    on<HomeInitialEvent>(_onInitialize);
  }

  _onInitialize(HomeInitialEvent event, Emitter<HomeState> emit) async {

  }
}
