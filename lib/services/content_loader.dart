import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hjalpguiden/models/guide.dart';
import 'package:hjalpguiden/utils/environment.dart';

class ContentLoader {
  static ContentBundle? _sharedBaseContent;
  static final Map<String, ContentBundle> _sharedTranslations = {};

  ContentBundle? _baseContent;
  final Map<String, ContentBundle> _translations = {};

  Future<void> loadBase() async {
    if (_baseContent != null) return;
    if (_sharedBaseContent != null) {
      _baseContent = _sharedBaseContent;
      return;
    }

    try {
      final jsonStr = await rootBundle.loadString(
        'assets/content/mvp-guides.json',
      );
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      _baseContent = ContentBundle.fromJson(json);
      _sharedBaseContent = _baseContent;
    } catch (error, stackTrace) {
      // ignore: avoid_print
      print('ContentLoader.loadBase error: $error');
      // ignore: avoid_print
      print(stackTrace);
      rethrow;
    }
  }

  Future<ContentBundle> loadForLanguage(String langCode) async {
    await loadBase();
    if (isFlutterTestEnvironment()) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    if (langCode == 'sv') {
      return _baseContent!;
    }

    if (_translations.containsKey(langCode)) {
      return _translations[langCode]!;
    }
    if (_sharedTranslations.containsKey(langCode)) {
      final bundle = _sharedTranslations[langCode]!;
      _translations[langCode] = bundle;
      return bundle;
    }

    try {
      final translationPath = 'assets/content/mvp-$langCode.json';
      final jsonStr = await rootBundle.loadString(translationPath);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final translation = ContentBundle.fromJson(json);

      final merged = _mergeContent(_baseContent!, translation);
      _translations[langCode] = merged;
      _sharedTranslations[langCode] = merged;
      return merged;
    } catch (e) {
      // Fallback to base if translation not found
      return _baseContent!;
    }
  }

  ContentBundle _mergeContent(ContentBundle base, ContentBundle translation) {
    final mergedGuides = <Guide>[];

    for (final baseGuide in base.guides) {
      final translationGuide = translation.guides.firstWhere(
        (g) => g.id == baseGuide.id,
        orElse: () => baseGuide,
      );

      final mergedTitle = _mergeTitle(
        baseGuide.title,
        translationGuide.title,
      );

      final mergedPrereq = _mergeLangLines(
        baseGuide.prereq,
        translationGuide.prereq,
      );

      final mergedSteps = _mergeSteps(baseGuide.steps, translationGuide.steps);

      final mergedTroubleshoot = _mergeTroubles(
        baseGuide.troubleshoot,
        translationGuide.troubleshoot,
      );

      mergedGuides.add(
        Guide(
          id: baseGuide.id,
          module: baseGuide.module,
          title: mergedTitle,
          prereq: mergedPrereq,
          steps: mergedSteps,
          troubleshoot: mergedTroubleshoot,
          sources: baseGuide.sources,
          lastVerified: baseGuide.lastVerified,
        ),
      );
    }

    return ContentBundle(guides: mergedGuides);
  }

  LangLine _mergeTitle(LangLine base, LangLine translation) {
    return LangLine(
      svEnkel: base.svEnkel,
      hs: translation.hs.isNotEmpty ? translation.hs : base.hs,
    );
  }

  List<LangLine> _mergeLangLines(
    List<LangLine> base,
    List<LangLine> translation,
  ) {
    final result = <LangLine>[];
    for (int i = 0; i < base.length; i++) {
      if (i < translation.length) {
        result.add(LangLine(svEnkel: base[i].svEnkel, hs: translation[i].hs));
      } else {
        result.add(base[i]);
      }
    }
    return result;
  }

  List<Step> _mergeSteps(List<Step> base, List<Step> translation) {
    final result = <Step>[];
    for (int i = 0; i < base.length; i++) {
      if (i < translation.length) {
        result.add(
          Step(
            svEnkel: base[i].svEnkel,
            hs: translation[i].hs,
            icon: base[i].icon,
          ),
        );
      } else {
        result.add(base[i]);
      }
    }
    return result;
  }

  List<Trouble> _mergeTroubles(List<Trouble> base, List<Trouble> translation) {
    final result = <Trouble>[];
    for (int i = 0; i < base.length; i++) {
      if (i < translation.length) {
        result.add(
          Trouble(
            svEnkel: base[i].svEnkel,
            hs: translation[i].hs,
            stepIndex: base[i].stepIndex,
          ),
        );
      } else {
        result.add(base[i]);
      }
    }
    return result;
  }
}
