import 'package:json_annotation/json_annotation.dart';

part 'guide.g.dart';

enum Module {
  BankID,
  m1177,
  Kivra,
  AF,
  Skatteverket,
  FK,
  Epost,
  Mobil,
  AI,
  Kommun,
  Trygghet
}

@JsonSerializable()
class LangLine {
  @JsonKey(name: 'sv_enkel')
  final String svEnkel;
  
  @JsonKey(name: 'hs')
  final String hs;

  const LangLine({
    required this.svEnkel,
    required this.hs,
  });

  factory LangLine.fromJson(Map<String, dynamic> json) =>
      _$LangLineFromJson(json);
  
  Map<String, dynamic> toJson() => _$LangLineToJson(this);
  
  LangLine copyWith({String? svEnkel, String? hs}) {
    return LangLine(
      svEnkel: svEnkel ?? this.svEnkel,
      hs: hs ?? this.hs,
    );
  }
}

@JsonSerializable()
class GuideStep extends LangLine {
  final String? icon;

  const GuideStep({
    required super.svEnkel,
    required super.hs,
    this.icon,
  });

  factory GuideStep.fromJson(Map<String, dynamic> json) => _$GuideStepFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$GuideStepToJson(this);
  
  @override
  GuideStep copyWith({String? svEnkel, String? hs, String? icon}) {
    return GuideStep(
      svEnkel: svEnkel ?? this.svEnkel,
      hs: hs ?? this.hs,
      icon: icon ?? this.icon,
    );
  }
}

@JsonSerializable()
class Trouble extends LangLine {
  final int? stepIndex;

  const Trouble({
    required super.svEnkel,
    required super.hs,
    this.stepIndex,
  });

  factory Trouble.fromJson(Map<String, dynamic> json) =>
      _$TroubleFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$TroubleToJson(this);
  
  @override
  Trouble copyWith({String? svEnkel, String? hs, int? stepIndex}) {
    return Trouble(
      svEnkel: svEnkel ?? this.svEnkel,
      hs: hs ?? this.hs,
      stepIndex: stepIndex ?? this.stepIndex,
    );
  }
}

@JsonSerializable()
class Guide {
  final String id;
  
  @JsonKey(unknownEnumValue: Module.m1177)
  final Module module;
  
  final String title;
  final List<LangLine> prereq;
  final List<GuideStep> steps;
  final List<Trouble> troubleshoot;
  final List<Map<String, String>> sources;
  final String? lastVerified;

  const Guide({
    required this.id,
    required this.module,
    required this.title,
    required this.prereq,
    required this.steps,
    required this.troubleshoot,
    required this.sources,
    this.lastVerified,
  });

  factory Guide.fromJson(Map<String, dynamic> json) => _$GuideFromJson(json);
  
  Map<String, dynamic> toJson() => _$GuideToJson(this);
}

@JsonSerializable()
class ContentBundle {
  final List<Guide> guides;

  const ContentBundle({required this.guides});

  factory ContentBundle.fromJson(Map<String, dynamic> json) =>
      _$ContentBundleFromJson(json);
  
  Map<String, dynamic> toJson() => _$ContentBundleToJson(this);
}