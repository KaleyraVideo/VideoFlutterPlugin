// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? hintText;
  final String labelText;

  const InputField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.hintText,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: hintText,
            labelText: labelText),
      ),
    );
  }
}
