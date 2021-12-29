import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/cart_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/providers/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/https_exception.dart';

enum AuthMode { Signup, Login, EnterCode, EnterName }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(79, 46, 172, 1).withOpacity(0.9),
                  const Color.fromRGBO(241, 117, 40, 1).withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    // child: Container(
                    //   margin: const EdgeInsets.only(bottom: 20.0),
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 8.0, horizontal: 94.0),
                    //   transform: Matrix4.rotationZ(-8 * pi / 180)
                    //     ..translate(-10.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     color: Theme.of(context).primaryColor,
                    //     boxShadow: const [
                    //       BoxShadow(
                    //         blurRadius: 8,
                    //         color: Colors.black26,
                    //         offset: Offset(0, 2),
                    //       )
                    //     ],
                    //   ),
                    //   child: const Text(
                    //     'Feshta',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 50,
                    //       fontFamily: 'Anton',
                    //       fontWeight: FontWeight.normal,
                    //     ),
                    //   ),
                    // ),
                    child: Container(
                      width: 170,
                      height: 170,
                      child: Image.asset('assets/images/icon.png'),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, dynamic> _authData = {
    'email': '',
    'password': '',
    'phoneNum': '',
    'acceptTerms': false,
    'code': '',
    'firstName': '',
    'lastName': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _phoneTxtFieldController = TextEditingController(text: '0911121314');
  String _defaultPhoneNum = '0911121314';

  Widget _buildEmailTextField() {
    return _authMode == AuthMode.Login || _authMode == AuthMode.Signup
        ? TextFormField(
            decoration: const InputDecoration(labelText: 'E-Mail'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value) ||
                  value.isEmpty) {
                return 'Invalid email!';
              }
            },
            onSaved: (value) {
              _authData['email'] = value!;
            },
          )
        : Container();
  }

  Widget _buildPasswordTextField() {
    return _authMode == AuthMode.Login || _authMode == AuthMode.Signup
        ? TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.length < 8 || value.isEmpty) {
                return 'Password is too short!';
              }
            },
            onSaved: (value) {
              _authData['password'] = value!;
            },
          )
        : Container();
  }

  Widget _buildConfirmPasswordTextField() {
    return _authMode == AuthMode.Signup
        ? TextFormField(
            enabled: _authMode == AuthMode.Signup,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: _authMode == AuthMode.Signup
                ? (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                  }
                : null,
          )
        : Container();
  }

  Widget _buildPhoneTextField() {
    return _authMode == AuthMode.Signup
        ? TextFormField(
            enabled: _authMode == AuthMode.Signup,
            controller: _phoneTxtFieldController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: _authMode == AuthMode.Signup
                ? (String? value) {
                    if (value == null ||
                        value.compareTo('0911121314') == 0 ||
                        value.length != 10 ||
                        value.isEmpty ||
                        value.substring(0, 2).compareTo('09') != 0) {
                      return 'Invalid Password';
                    }
                  }
                : null,
            onTap: () {
              setState(() {
                if (_phoneTxtFieldController.text.compareTo('0911121314') ==
                    0) {
                  _phoneTxtFieldController.text = '';
                }
              });
            },
            onSaved: (String? value) {
              _authData['phoneNum'] = '+251' + value!.substring(1);
            },
          )
        : Container();
  }

  Widget _buildCodeTextBox() {
    return _authMode == AuthMode.EnterCode
        ? TextFormField(
            decoration: const InputDecoration(labelText: '4Digit Code'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null ||
                  value.length != 4 ||
                  !RegExp(r'[0-9]').hasMatch(value)) {
                return 'Invalid code';
              }
            },
            onSaved: (String? value) {
              _authData['code'] = value!;
            },
          )
        : Container();
  }

  Widget _buildFirstNameTextBox() {
    return _authMode == AuthMode.EnterName
        ? TextFormField(
            decoration: const InputDecoration(labelText: 'First Name'),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.length < 2 || value.length > 8) {
                return 'Your name must be between 2 - 8 digits';
              }
            },
            onSaved: (value) {
              _authData['firstName'] = value;
            },
          )
        : Container();
  }

  Widget _buildLastNameTextBox() {
    return _authMode == AuthMode.EnterName
        ? TextFormField(
            decoration: const InputDecoration(labelText: 'Last Name'),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.length < 2 || value.length > 8) {
                return 'Your name must be between 2 - 8 digits';
              }
            },
            onSaved: (value) {
              _authData['lasName'] = value;
            },
          )
        : Container();
  }

  Widget _buildAcceptSwitch() {
    return _authMode == AuthMode.Login || _authMode == AuthMode.Signup
        ? SwitchListTile(
            value: _authData['acceptTerms'],
            onChanged: (bool value) {
              setState(() {
                _authData['acceptTerms'] = value;
              });
            },
            title: const Text('Accept Terms'),
          )
        : Container();
  }

  Widget _buildAuthBtn() {
    return _authMode == AuthMode.Login || _authMode == AuthMode.Signup
        ? ElevatedButton(
            child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
            onPressed: _submitAuth,
            style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                padding: MaterialStateProperty.resolveWith((states) =>
                    const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor)),
          )
        : Container();
  }

  Widget _buildSendCodeBtn() {
    return _authMode == AuthMode.EnterCode
        ? ElevatedButton(
            onPressed: _verifyCode,
            child: const Text('Verify'),
            style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                padding: MaterialStateProperty.resolveWith((states) =>
                    const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor)),
          )
        : Container();
  }

  Widget _buildSendNameBtn() {
    return _authMode == AuthMode.EnterName
        ? ElevatedButton(
            onPressed: _updateName,
            child: const Text('Continue'),
            style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                padding: MaterialStateProperty.resolveWith((states) =>
                    const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor)),
          )
        : Container();
  }

  Widget _buildSwitchAuthModeBtn() {
    return _authMode == AuthMode.Login || _authMode == AuthMode.Signup
        ? TextButton(
            child: Text(
                '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
            onPressed: _switchAuthMode,
            style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: MaterialStateProperty.resolveWith((states) =>
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4)),
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor)),
          )
        : Container();
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .verifyCode(_authData['code'], _authData['phoneNum']);
      setState(() {
        _isLoading = false;
        _authMode = AuthMode.EnterName;
      });
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(error.toString());
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Something went wrong!');
    }
  }

  Future<void> _updateName() async {
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .login(_authData['email'], _authData['password']);
      await Provider.of<UserProvider>(context, listen: false).updateProfile(
          _authData['firstName'],
          _authData['lastName'],
          _authData['password'],
          _authData['password'],
          true,
          _authData['email']);
      Navigator.pushReplacementNamed(context, '/tabPage');
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(error.toString());
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Something went wrong!');
    }
  }

  Future<void> _submitAuth() async {
    if (!_formKey.currentState!.validate() || !_authData['acceptTerms']) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    print(
        '${_authData['email']} ${_authData['password']} ${_authData['phoneNum']}');
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<UserProvider>(context, listen: false)
            .login(
          _authData['email']!,
          _authData['password']!,
        )
            .then((value) {
          Provider.of<EventProvider>(context, listen: false)
              .isFavoriteFetchedSetter = false;
          Provider.of<ArtistProvider>(context, listen: false)
              .isFavoriteFetchedSetter = false;
          Provider.of<HostProvider>(context, listen: false)
              .isFavoriteFetchedSetter = false;
          Provider.of<TicketProvider>(context, listen: false)
              .isActiveTicketsFetchedSetter = false;
          Provider.of<TicketProvider>(context, listen: false)
              .isPastTicketsFetchedSetter = false;
          Provider.of<CartProvider>(context, listen: false)
              .isCartFetchedSetter = false;
        });
        Navigator.pushReplacementNamed(context, '/tabPage',
            arguments: 'loggedIn');
      } else {
        // Sign user up
        await Provider.of<UserProvider>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
            _authData['phoneNum']!);
        setState(() {
          _isLoading = false;
          _authMode = AuthMode.EnterCode;
        });
      }
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
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
        height: _authMode == AuthMode.Signup
            ? 398
            : _authMode == AuthMode.Login
                ? 325
                : _authMode == AuthMode.EnterCode
                    ? 210
                    : 270,
        constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup
                ? 320
                : _authMode == AuthMode.Login
                    ? 260
                    : _authMode == AuthMode.EnterCode
                        ? 180
                        : 240),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailTextField(),
                _buildPasswordTextField(),
                _buildConfirmPasswordTextField(),
                _buildPhoneTextField(),
                _buildAcceptSwitch(),
                if (_isLoading &&
                    (_authMode == AuthMode.Login ||
                        _authMode == AuthMode.Signup))
                  const CircularProgressIndicator()
                else
                  _buildAuthBtn(),
                _buildSwitchAuthModeBtn(),
                _authMode == AuthMode.EnterCode
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                _buildCodeTextBox(),
                _authMode == AuthMode.EnterCode
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),
                if (_isLoading && _authMode == AuthMode.EnterCode)
                  const CircularProgressIndicator()
                else
                  _buildSendCodeBtn(),
                _buildFirstNameTextBox(),
                _buildLastNameTextBox(),
                const SizedBox(
                  height: 15,
                ),
                if (_isLoading && _authMode == AuthMode.EnterName)
                  const CircularProgressIndicator()
                else
                  _buildSendNameBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
