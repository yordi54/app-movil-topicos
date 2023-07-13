import 'package:flutter/material.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      // Cuando se ingresa un carácter y no es el último campo, pasa al siguiente
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            width: 40,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              controller: controllers[i],
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
              focusNode: focusNodes[i],
              onChanged: (value) {
                _handleTextChanged(i, value);
              },
            ),
          ),
      ],
    );
  }
}
