import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialise extends AuthEvent {
  const AuthEventInitialise();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}
