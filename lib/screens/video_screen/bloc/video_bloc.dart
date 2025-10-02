import 'package:assessment/core/utils/navigator_service.dart' show NavigatorService;
import 'package:assessment/core/utils/pref_utils.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/screens/video_screen/models/video_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'video_event.dart';
part 'video_state.dart';

/// A bloc that manages the state of a Pgcommercial according to the event that is dispatched to it.
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(VideoState initialState) : super(initialState) {
    on<VideoInitialEvent>(_onInitialize);
  }

  _onInitialize(VideoInitialEvent event, Emitter<VideoState> emit) async {

  }
}
