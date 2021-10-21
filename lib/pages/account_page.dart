import 'package:feshta/pages/auth.dart';
import 'package:feshta/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountPage();
  }
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget? child, MainModel model) {
        return model.isLoggedIn
            ? Container(
                child: const Center(
                  child: Text("Account"),
                ),
              )
            : AuthPage();
      },
    );
  }
}
