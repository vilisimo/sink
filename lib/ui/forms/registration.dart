import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/buttons.dart';
import 'package:sink/ui/common/form_errors.dart';
import 'package:sink/ui/common/text_input.dart';

class RegistrationForm extends StatefulWidget {
  static const route = '/register';

  @override
  State<StatefulWidget> createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
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
    return StoreConnector<AppState, _RegistrationFormViewModel>(
      converter: _RegistrationFormViewModel.fromState,
      builder: (context, vm) {
        final errorMessage = vm.errorMessage;
        final registering = vm.registrationInProgress;
        final button = registering
            ? LoadingButton()
            : RoundedButton(text: "Register", onPressed: () => _save(vm));

        var baseForm = <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text('Register', style: Theme.of(context).textTheme.headline),
            ),
          ),
          EmailFormField(
            key: ValueKey("Registration email"),
            onSaved: _onEmailSaved,
          ),
          RegistrationPasswordFormField(
            key: ValueKey("Registration password"),
            onSaved: _onPasswordSaved,
          ),
          button,
          if (errorMessage != "") FormError(errorMessage),
          RegistrationToSignInText(
            plainText: "Already have an account?",
            hyperlinkedText: "Sign in here!",
            center: true,
          ),
        ];

        if (vm.registrationSuccessful) {
          return RegistrationSuccessScreen();
        }

        return Scaffold(
          body: Center(
            child: Form(
              key: _formKey,
              child: ListView(shrinkWrap: true, children: baseForm),
            ),
          ),
        );
      },
    );
  }

  void _save(_RegistrationFormViewModel vm) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      vm.registerUser(_email, _password);
    }
  }
}

class _RegistrationFormViewModel {
  final Function(String, String) registerUser;
  final bool registrationInProgress;
  final bool registrationSuccessful;
  final String errorMessage;

  _RegistrationFormViewModel({
    @required this.registerUser,
    @required this.registrationInProgress,
    @required this.registrationSuccessful,
    @required this.errorMessage,
  });

  static _RegistrationFormViewModel fromState(Store<AppState> store) {
    return _RegistrationFormViewModel(
      registerUser: (String email, String password) => store.dispatch(
        Register(email: email, password: password),
      ),
      registrationInProgress: isRegistrationInProgress(store.state),
      registrationSuccessful: isRegistrationSuccessful(store.state),
      errorMessage: getAuthenticationErrorMessage(store.state),
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Registration successful!',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
              child: Text(
                "Please check your email for verification link. "
                "Once email is verified, you will be able to sign in "
                "and start using the app.",
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
              child: RegistrationToSignInText(
                plainText: "Already verified your account?",
                hyperlinkedText: "Sign in here!",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationToSignInText extends StatelessWidget {
  final String plainText;
  final String hyperlinkedText;
  final bool center;

  RegistrationToSignInText({
    @required this.plainText,
    @required this.hyperlinkedText,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _RegistrationBackButtonViewModel>(
      converter: _RegistrationBackButtonViewModel.fromState,
      builder: (context, vm) {
        return Row(
          mainAxisAlignment: center != null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: <Widget>[
            Text("$plainText "),
            InkWell(
              child: Text(
                hyperlinkedText,
                style: Theme.of(context).textTheme.body1.copyWith(
                      color: Colors.blue,
                    ),
              ),
              onTap: () {
                vm.clearRegistrationState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _RegistrationBackButtonViewModel {
  final Function clearRegistrationState;

  _RegistrationBackButtonViewModel({@required this.clearRegistrationState});

  static _RegistrationBackButtonViewModel fromState(Store<AppState> store) {
    return _RegistrationBackButtonViewModel(
      clearRegistrationState: () => store.dispatch(ClearAuthenticationState()),
    );
  }
}
