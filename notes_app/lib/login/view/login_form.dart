import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/login/bloc/login_bloc.dart';
import 'package:notes_app/login/bloc/login_event.dart';
import 'package:notes_app/login/bloc/login_state.dart';
import 'package:notes_app/login/view/login_page.dart';
import 'package:notes_app/notes_overview/view/notes_overview_page.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.error.trim().isNotEmpty) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Login Failure " + state.error)),
            );
        }
        if (state is LoginState_LoggedIn) {
          Navigator.of(context).push(
            MaterialPageRoute<NotesOverviewPage>(
              builder: (_) => NotesOverviewPage(),
            ),
          );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      // buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_password'),
          onChanged: (password) => context.read<LoginBloc>().add(PasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            errorText: state.error,
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state is LoginState_InProgress
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green,
                          key: const Key('loginForm_continue'),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => context.read<LoginBloc>().add(const PasswordSubmitted()),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green,
                          key: const Key('loginForm_delete_all'),
                          child: const Text(
                            'I don\'t remember my password. Delete all data',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => context.read<LoginBloc>().add(const WipeData()),
                        ),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}
