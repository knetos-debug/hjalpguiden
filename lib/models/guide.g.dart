// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LangLine _$LangLineFromJson(Map<String, dynamic> json) =>
    LangLine(svEnkel: json['sv_enkel'] as String, hs: json['hs'] as String);

Map<String, dynamic> _$LangLineToJson(LangLine instance) => <String, dynamic>{
  'sv_enkel': instance.svEnkel,
  'hs': instance.hs,
};

Step _$StepFromJson(Map<String, dynamic> json) => Step(
  svEnkel: json['sv_enkel'] as String,
  hs: json['hs'] as String,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
  'sv_enkel': instance.svEnkel,
  'hs': instance.hs,
  'icon': instance.icon,
};

Trouble _$TroubleFromJson(Map<String, dynamic> json) => Trouble(
  svEnkel: json['sv_enkel'] as String,
  hs: json['hs'] as String,
  stepIndex: (json['stepIndex'] as num?)?.toInt(),
);

Map<String, dynamic> _$TroubleToJson(Trouble instance) => <String, dynamic>{
  'sv_enkel': instance.svEnkel,
  'hs': instance.hs,
  'stepIndex': instance.stepIndex,
};

Guide _$GuideFromJson(Map<String, dynamic> json) => Guide(
  id: json['id'] as String,
  module: $enumDecode(
    _$ModuleEnumMap,
    json['module'],
    unknownValue: Module.m1177,
  ),
  title: LangLine.fromJson(json['title'] as Map<String, dynamic>),
  prereq: (json['prereq'] as List<dynamic>)
      .map((e) => LangLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>)
      .map((e) => Step.fromJson(e as Map<String, dynamic>))
      .toList(),
  troubleshoot: (json['troubleshoot'] as List<dynamic>)
      .map((e) => Trouble.fromJson(e as Map<String, dynamic>))
      .toList(),
  sources: (json['sources'] as List<dynamic>)
      .map((e) => Map<String, String>.from(e as Map))
      .toList(),
  lastVerified: json['lastVerified'] as String?,
);

Map<String, dynamic> _$GuideToJson(Guide instance) => <String, dynamic>{
  'id': instance.id,
  'module': _$ModuleEnumMap[instance.module]!,
  'title': instance.title,
  'prereq': instance.prereq,
  'steps': instance.steps,
  'troubleshoot': instance.troubleshoot,
  'sources': instance.sources,
  'lastVerified': instance.lastVerified,
};

const _$ModuleEnumMap = {
  Module.BankID: 'BankID',
  Module.m1177: 'm1177',
  Module.Kivra: 'Kivra',
  Module.AF: 'AF',
  Module.Skatteverket: 'Skatteverket',
  Module.FK: 'FK',
  Module.Epost: 'Epost',
  Module.Mobil: 'Mobil',
  Module.AI: 'AI',
  Module.Kommun: 'Kommun',
  Module.Trygghet: 'Trygghet',
};

ContentBundle _$ContentBundleFromJson(Map<String, dynamic> json) =>
    ContentBundle(
      guides: (json['guides'] as List<dynamic>)
          .map((e) => Guide.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContentBundleToJson(ContentBundle instance) =>
    <String, dynamic>{'guides': instance.guides};
