import 'package:flutter/material.dart';

import '../widgets/stepper_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: StepperWidget(context: context),
    );
  }
  
  
}
