import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/buttons.dart';
import 'package:sink/ui/common/form_errors.dart';
import 'package:sink/ui/common/text_input.dart';

class SignInForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  void _onEmailSaved(String value) {
    _email = value.trim();
  }

  void _onPasswordSaved(String value) {
    _password = value;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SignInViewModel>(
      converter: _SignInViewModel.fromState,
      builder: (context, vm) {
        final errorMessage = vm.errorMessage;
        final signingIn = vm.signInInProgress;
        final button = signingIn
            ? LoadingButton()
            : RoundedButton(
                text: "Sign In",
                onPressed: () => _save(() => vm.signIn(_email, _password)),
              );

        var baseForm = <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text('Sign In', style: Theme.of(context).textTheme.headline),
            ),
          ),
          EmailFormField(
            key: ValueKey("SignIn email"),
            onSaved: _onEmailSaved,
          ),
          SignInPasswordFormField(
            key: ValueKey("SignIn password"),
            onSaved: _onPasswordSaved,
            showHelpText: false,
          ),
          if (errorMessage != "") FormError(errorMessage),
          button,
        ];

        return Center(
          child: Form(
            key: _formKey,
            child: ListView(shrinkWrap: true, children: baseForm),
          ),
        );
      },
    );
  }

  void _save(Function signIn) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signIn();
    }
  }
}

class _SignInViewModel {
  final Function(String, String) signIn;
  final bool signInInProgress;
  final String errorMessage;

  _SignInViewModel({
    @required this.signIn,
    @required this.signInInProgress,
    @required this.errorMessage,
  });

  static _SignInViewModel fromState(Store<AppState> store) {
    return _SignInViewModel(
      signIn: (String email, String password) => store.dispatch(
        SignIn(email: email, password: password),
      ),
      signInInProgress: isSignInInProgress(store.state),
      errorMessage: getAuthenticationErrorMessage(store.state),
    );
  }
}
