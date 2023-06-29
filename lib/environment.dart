// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

///
/// Available environments
///
class Environment {

  /// @nodoc
  final String name;

  ///
  /// @nodoc
  /// 
  Environment({required this.name});

  ///
  /// Sandbox environment
  ///
  factory Environment.sandbox() = SandboxEnvironment;

  ///
  /// Production environment
  ///
  factory Environment.production() = ProductionEnvironment;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
    "name": name
  };
}

/// @nodoc
class SandboxEnvironment extends Environment {
  SandboxEnvironment() : super(name: "sandbox");
}

/// @nodoc
class ProductionEnvironment extends Environment {
  ProductionEnvironment() : super(name: "production");
}