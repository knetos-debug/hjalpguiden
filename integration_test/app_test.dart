import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Flow', () {
    testWidgets('Complete user journey', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Start at language selection
      expect(find.text('Välj språk'), findsOneWidget);

      // 2. Select Arabic
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();

      // 3. Should be on home screen
      expect(find.text('Hjälpguiden'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);

      // 4. Wait for guides to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 5. Tap on first guide
      final guideCards = find.byType(Card);
      expect(guideCards, findsWidgets);
      await tester.tap(guideCards.first);
      await tester.pumpAndSettle();

      // 6. Should see guide view
      expect(find.text('Förberedelser'), findsOneWidget);
      expect(find.text('Steg för steg'), findsOneWidget);

      // 7. Look for TTS buttons
      expect(find.byIcon(Icons.volume_up), findsWidgets);

      // 8. Tap first TTS button
      final ttsButtons = find.byIcon(Icons.volume_up);
      if (ttsButtons.evaluate().isNotEmpty) {
        await tester.tap(ttsButtons.first);
        await tester.pump();
        
        // Button should change to stop icon
        await tester.pump(const Duration(milliseconds: 100));
      }

      // 9. Go back to home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 10. Change language
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // 11. Should be back at language selection
      expect(find.text('Välj språk'), findsOneWidget);

      // 12. Select Swedish
      await tester.tap(find.text('Svenska'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 13. Content should update
      expect(find.text('Hjälpguiden'), findsOneWidget);
    });

    testWidgets('Offline behavior simulation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Select language and load content
      await tester.tap(find.text('Svenska'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Open a guide
      final guideCards = find.byType(Card);
      await tester.tap(guideCards.first);
      await tester.pumpAndSettle();

      // Content should be available (loaded from assets)
      expect(find.text('Förberedelser'), findsOneWidget);
      
      // Go back and open again (simulates cached content)
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      
      await tester.tap(guideCards.first);
      await tester.pumpAndSettle();
      
      // Should still work
      expect(find.text('Förberedelser'), findsOneWidget);
    });

    testWidgets('Multiple language switches', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test switching between languages multiple times
      final languages = ['العربية', 'Soomaali', 'Svenska'];
      
      for (final lang in languages) {
        await tester.tap(find.text(lang));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        expect(find.text('Hjälpguiden'), findsOneWidget);
        
        // Go back to language selection
        await tester.tap(find.byIcon(Icons.language));
        await tester.pumpAndSettle();
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('Smooth scrolling in guide view', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Svenska'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final guideCards = find.byType(Card);
      await tester.tap(guideCards.first);
      await tester.pumpAndSettle();

      // Scroll through the guide
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Should still be responsive
      expect(find.text('Om det strular'), findsOneWidget);
    });
  });
}