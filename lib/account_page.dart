import 'package:flutter/material.dart';

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
    return Container(
      child: Center(
        child: Text("Account"),
      ),
    );
  }
}
