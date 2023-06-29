// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:flutter/material.dart';

class KaleyraLogoHeader extends StatelessWidget {
  const KaleyraLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 32,
        ),
        Image(
          image: AssetImage("lib/images/logo.png"),
          height: 64,
        ),
        SizedBox(
          height: 64,
        ),
      ],
    );
  }
}
