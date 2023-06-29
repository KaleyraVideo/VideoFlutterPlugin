// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:flutter/material.dart';

//ignore: must_be_immutable
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  bool enabled;

  ActionButton({super.key, required this.label, required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) => Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: enabled ? onPressed : null,
            child: Text(label),
          ),
        ),
      );
}
