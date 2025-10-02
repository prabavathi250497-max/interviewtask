  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assessment/data/repository/auth_repository.dart';



import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;


  AuthBloc({required this.authRepository}) : super(AuthUnauthenticated()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }


  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final token = await authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(token: token));
    } catch (e) {
// Emit failure then go back to unauthenticated so the form is usable again
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      emit(AuthUnauthenticated());
    }
  }


  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}