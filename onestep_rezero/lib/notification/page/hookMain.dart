import 'package:flutter/material.dart';
import 'package:onestep_rezero/login/controllers/auth_controller.dart';
//import 'package:firebase_core/firebase_core.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "dd",
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    //final authControllerState = useProvider(authControllerProvider.state);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appbar")),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

// class HomeScreen2 extends HookWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authControllerState = useProvider(authControllerProvider.state);
//     return Scaffold(
//       appBar: AppBar(title: const Text("Appbar")),
//     );
//   }
// }
