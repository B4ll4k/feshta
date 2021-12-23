import 'package:feshta/models/user.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const String route = '/editProfilePage';
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool showPassword = false;
  final Map<String, dynamic> _userData = {
    'firstName': '',
    'lastName': '',
    'password': '',
    'newPassword': ''
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<UserProvider>(context, listen: false).updateProfile(
          _userData['firstName'],
          _userData['lastName'],
          _userData['password'],
          _userData['newPassword'],
          false,
          '');
      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) async {
    await showDialog(
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

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Successful!'),
        content: const Text('Profile Successfuly Updated'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).popUntil((ModalRoute.withName('/tabPage')));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    print(user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          _isLoading
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  onPressed: _submit,
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/640px-User_icon_2.svg.png",
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                buildTextField("First Name", user!.firstName, true),
                buildTextField('Last Name', user!.lastName, false),
                buildPasswordTextField("Password", "********", false, false),
                buildPasswordTextField('New Password', '********', false, true),
                buildPasswordTextField(
                    "Confirm Password", "********", true, false),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isFirstName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (newValue) {
          if (isFirstName) {
            _userData['firstName'] = newValue;
          } else {
            _userData['lastName'] = newValue;
          }
        },
        validator: (value) {
          return nameValidator(value);
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  Widget buildPasswordTextField(String labelText, String placeholder,
      bool isConfirmPassword, bool isNewPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (newValue) {
          if (isNewPassword) {
            _userData['newPassword'] = newValue;
          } else if (!isConfirmPassword) {
            _userData['password'] = newValue;
          }
        },
        controller: isNewPassword ? _passwordController : null,
        validator: (value) {
          if (!isConfirmPassword) {
            return passwordValidator(value);
          } else {
            return confirmPasswordValidator(value);
          }
        },
        obscureText: !showPassword,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            ),
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  Widget buildPhoneTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        onSaved: (newValue) {
          _userData['tel'] = newValue;
        },
        validator: (value) {
          if (value == null ||
              value.compareTo('0911121314') == 0 ||
              value.length != 10 ||
              value.isEmpty ||
              value.substring(0, 2).compareTo('09') != 0) {
            return 'Please check ypur phone number!';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  String? nameValidator(String? value) {
    if (value == null || value.length < 2 || value.length > 8) {
      return 'Your name must be between 2 - 8 digits';
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.length < 8 || value.isEmpty) {
      return 'Password is too short!';
    }
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value != _passwordController.text) {
      return 'Password must match!';
    }
  }
}
