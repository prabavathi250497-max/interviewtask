import 'package:assessment/core/utils/navigator_service.dart' show NavigatorService;
import 'package:assessment/core/utils/pref_utils.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/splash_screen/models/splash_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'splash_event.dart';
part 'splash_state.dart';

/// A bloc that manages the state of a Pgcommercial according to the event that is dispatched to it.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(SplashState initialState) : super(initialState) {
    on<SplashInitialEvent>(_onInitialize);
  }

  _onInitialize(SplashInitialEvent event, Emitter<SplashState> emit) async {
    Future.delayed(const Duration(milliseconds: 5000), () async {


      print(PrefUtils().getLoggedInUserId());
      if (PrefUtils().getLoggedInUserId() != '') {
        NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
      } else {
        NavigatorService.popAndPushNamed(AppRoutes.loginPageScreen);
      }
      // }
    });
  }
}
