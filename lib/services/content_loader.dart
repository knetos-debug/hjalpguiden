import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/guide.dart';

class ContentLoader {
  ContentBundle? _baseContent;
  final Map<String, ContentBundle> _translations = {};

  Future<void> loadBase() async {
    if (_baseContent != null) return;
    
    final jsonStr = await rootBundle.loadString('assets/content/mvp-guides.json');
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _baseContent = ContentBundle.fromJson(json);
  }

  Future<ContentBundle> loadForLanguage(String langCode) async {
    await loadBase();
    
    if (langCode == 'sv') {
      return _baseContent!;
    }

    if (_translations.containsKey(langCode)) {
      return _translations[langCode]!;
    }

    try {
      final translationPath = 'assets/content/mvp-$langCode.json';
      final jsonStr = await rootBundle.loadString(translationPath);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final translation = ContentBundle.fromJson(json);
      
      final merged = _mergeContent(_baseContent!, translation);
      _translations[langCode] = merged;
      return merged;
    } catch (e) {
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

      final mergedTitle = LangLine(
        svEnkel: baseGuide.title.svEnkel,
        hs: translationGuide.title.hs,
      );

      final mergedPrereq = _mergeLangLines(
        baseGuide.prereq,
        translationGuide.prereq,
      );

      final mergedSteps = _mergeSteps(
        baseGuide.steps,
        translationGuide.steps,
      );

      final mergedTroubleshoot = _mergeTroubles(
        baseGuide.troubleshoot,
        translationGuide.troubleshoot,
      );

      mergedGuides.add(Guide(
        id: baseGuide.id,
        module: baseGuide.module,
        title: mergedTitle,
        prereq: mergedPrereq,
        steps: mergedSteps,
        troubleshoot: mergedTroubleshoot,
        sources: baseGuide.sources,
        lastVerified: baseGuide.lastVerified,
      ));
    }

    return ContentBundle(guides: mergedGuides);
  }

  List<LangLine> _mergeLangLines(List<LangLine> base, List<LangLine> translation) {
    final result = <LangLine>[];
    for (int i = 0; i < base.length; i++) {
      if (i < translation.length) {
        result.add(LangLine(
          svEnkel: base[i].svEnkel,
          hs: translation[i].hs,
        ));
      } else {
        result.add(base[i]);
      }
    }
    return result;
  }

  List<GuideStep> _mergeSteps(List<GuideStep> base, List<GuideStep> translation) {
    final result = <GuideStep>[];
    for (int i = 0; i < base.length; i++) {
      if (i < translation.length) {
        result.add(GuideStep(
          svEnkel: base[i].svEnkel,
          hs: translation[i].hs,
          icon: base[i].icon,
        ));
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
        result.add(Trouble(
          svEnkel: base[i].svEnkel,
          hs: translation[i].hs,
          stepIndex: base[i].stepIndex,
        ));
      } else {
        result.add(base[i]);
      }
    }
    return result;
  }
}