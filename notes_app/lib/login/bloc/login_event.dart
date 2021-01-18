import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;
}

class PasswordSubmitted extends LoginEvent {
  const PasswordSubmitted();
}

class WipeData extends LoginEvent {
  const WipeData();
}