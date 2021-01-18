class LoginState {
  const LoginState({
    this.password = "",
    this.error = "",
    this.securityKey = "",
  });

  LoginState.fromSelf(LoginState loginState, {String username, String password, String error, String securityKey})
      : this.password = password ?? loginState.password,
        this.error = error ?? loginState.error,
        this.securityKey = securityKey ?? loginState.securityKey;

  final String password;
  final String error;
  final String securityKey;
}

class LoginState_InProgress extends LoginState {
  LoginState_InProgress(LoginState loginState) : super.fromSelf(loginState);
}

class LoginState_NotLoggedIn extends LoginState {
  LoginState_NotLoggedIn(LoginState loginState, {String securityKey, String password, String error})
      : super.fromSelf(loginState, securityKey: securityKey,  password: password, error: error);
}

class LoginState_LoggedIn extends LoginState {
  LoginState_LoggedIn(LoginState loginState, String securityKey) : super.fromSelf(loginState, securityKey: securityKey);
}
