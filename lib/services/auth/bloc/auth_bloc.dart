import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoading: true)) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    //register
    on<AuthEventRegsiter>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsverification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegsitering(exception: e, isLoading: false));
      }
    });

    // initialise
    on<AuthEventInitialise>((event, emit) async {
      await provider.intialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(isLoading: false, exception: null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsverification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // log in
    on<AuthEventLogin>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          isLoading: true,
          exception: null,
          loadingText: 'Please wait while I log you in..',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(isLoading: false, exception: null));
          emit(const AuthStateNeedsverification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(isLoading: false, exception: null));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });

    // log out
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(isLoading: false, exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });
  }
}
