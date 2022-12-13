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

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _controller;

  late Animation<double> _opacityanimation;

  late Animation<Offset> _slideanimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _opacityanimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _slideanimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  void _shwoErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("An error has ocurred"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"))
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
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
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
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        height: _authMode == AuthMode.Login ? 322 : 371,
        // height: _heightanimation.value.height,
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
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
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return "Invalid Password";
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value.toString(),
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate,
                child: FadeTransition(
                  opacity: _opacityanimation,
                  child: SlideTransition(
                    position: _slideanimation,
                    child: TextFormField(
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return "Passwords must be the same";
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).primaryTextTheme.button!.color,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0)),
                  onPressed: _submit,
                  child:
                      Text(_authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER'),
                ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                    "CHANGE TO ${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'}"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
