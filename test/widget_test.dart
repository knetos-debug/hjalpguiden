import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/app.dart';
import 'package:hjalpguiden/features/language/select_language_screen.dart';
import 'package:hjalpguiden/features/home/home_screen.dart';
import 'package:hjalpguiden/features/guides/guide_view.dart';
import 'package:hjalpguiden/providers/providers.dart';

void main() {
  group('Language Selection Tests', () {
    testWidgets('Language selection screen shows all languages', (
      tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: HjalpguidenApp()));
      await tester.pumpAndSettle();

      expect(find.text('Välj språk'), findsOneWidget);
      expect(find.text('Choose language'), findsOneWidget);

      // Check for some language options
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('Soomaali'), findsOneWidget);
      expect(find.text('Svenska'), findsOneWidget);
    });

    testWidgets('Language selection navigates to home', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: HjalpguidenApp()));
      await tester.pumpAndSettle();

      // Tap on Swedish
      await tester.tap(find.text('Svenska'));
      await tester.pumpAndSettle();

      // Should navigate to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('Guide View Tests', () {
    testWidgets('GuideView renders two lines per step', (tester) async {
      final container = ProviderContainer(
        overrides: [selectedLanguageProvider.overrideWith((ref) => 'sv')],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: GuideView(guideId: '1177-login-same')),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that steps are displayed
      expect(find.text('Förberedelser'), findsOneWidget);
      expect(find.text('Steg för steg'), findsOneWidget);
    });

    testWidgets('TTS button is visible for each step', (tester) async {
      final container = ProviderContainer(
        overrides: [selectedLanguageProvider.overrideWith((ref) => 'ar')],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: GuideView(guideId: '1177-login-same')),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for volume icons (TTS buttons)
      expect(find.byIcon(Icons.volume_up), findsWidgets);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('Buttons have minimum touch target size', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: HjalpguidenApp()));
      await tester.pumpAndSettle();

      // Check language buttons
      final buttons = find.byType(InkWell);
      expect(buttons, findsWidgets);

      // Get first button size
      final buttonWidget = tester.widget<InkWell>(buttons.first);
      final renderBox = tester.renderObject(buttons.first) as RenderBox;

      // Should be at least 48x48 dp
      expect(renderBox.size.width, greaterThanOrEqualTo(48));
      expect(renderBox.size.height, greaterThanOrEqualTo(48));
    });

    testWidgets('Semantic labels are present', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: HjalpguidenApp()));
      await tester.pumpAndSettle();

      // Check for semantic labels
      expect(find.bySemanticsLabel('Välj Svenska'), findsOneWidget);
    });
  });

  group('Content Loading Tests', () {
    testWidgets('Home screen loads guides', (tester) async {
      final container = ProviderContainer(
        overrides: [selectedLanguageProvider.overrideWith((ref) => 'sv')],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      // Wait for loading
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for content
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show guide cards
      expect(find.byType(Card), findsWidgets);
    });
  });
}
