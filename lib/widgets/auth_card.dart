import 'package:flutter/material.dart';
import '../exceptions/auth_exception.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  void _shwoErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An error has ocurred"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        await auth.signin(
          _authData["email"].toString(),
          _authData["password"].toString(),
        );
      } else {
        await auth.signup(
          _authData["email"].toString(),
          _authData["password"].toString(),
        );
      }
    } on AuthException catch (error) {
      _shwoErrorDialog(error.toString());
    } catch (error) {
      _shwoErrorDialog("Unexpected error");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16),
          height: _authMode == AuthMode.Login ? 323 : 361,
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "Invalid E-mail";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value.toString(),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "Invalid Password";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value.toString(),
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "Passwords must be the same";
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).primaryTextTheme.button!.color,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0)),
                    onPressed: _submit,
                    child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      "CHANGE TO ${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'}"),
                )
              ],
            ),
          ),
        ));
  }
}
