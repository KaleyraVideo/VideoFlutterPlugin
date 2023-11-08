// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

///
/// A region where your integration will run
///
class Region {
  ///
  /// @nodoc
  ///
  final String name;

  /// @nodoc
  Region({required this.name});

  ///
  /// Europe region
  ///
  factory Region.europe() = EuropeRegion;

  ///
  /// India region
  ///
  factory Region.india() = IndiaRegion;

  ///
  /// US region
  ///
  factory Region.us() = USRegion;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {"name": name};
}

/// @nodoc
class EuropeRegion extends Region {
  EuropeRegion() : super(name: "europe");
}

/// @nodoc
class IndiaRegion extends Region {
  IndiaRegion() : super(name: "india");
}

/// @nodoc
class USRegion extends Region {
  USRegion() : super(name: "us");
}
