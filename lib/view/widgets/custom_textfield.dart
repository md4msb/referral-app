import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;

  const CustomTextField({Key? key, this.controller, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
          hintText: label,
          hintStyle: const TextStyle(
            color: Color(0xFFBBBBBB),
          ),
          prefixIcon: const Icon(Icons.person_outline_rounded),
          fillColor: const Color(formFill),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
