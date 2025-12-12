import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegsitering extends AuthState {
  final Exception? exception;
  const AuthStateRegsitering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsverification extends AuthState {
  const AuthStateNeedsverification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({required this.isLoading, required this.exception});

  @override
  List<Object?> get props => [exception, isLoading];
}
