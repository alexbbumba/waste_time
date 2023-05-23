import 'package:flutter/material.dart';

class InputFieldWithoutIcon extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final VoidCallback? tap;
  final bool x;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  const InputFieldWithoutIcon({
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.x = false,
    this.tap,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        validator: ((value) =>
            value!.isNotEmpty ? null : "This field is required"),
        controller: controller,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        onTap: tap,
        readOnly: x,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 15),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            suffixIcon: suffixIcon,
            suffixStyle: const TextStyle(color: Colors.green)),
        onChanged: onChanged,
      ),
    );
  }
}
