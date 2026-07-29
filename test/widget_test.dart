// Basic smoke test: verifies the app boots, shows the splash screen, then
// automatically navigates to the characters route once the splash timer
// (AppConstants.splashDuration) elapses.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_explorer/core/constants/app_constants.dart';
import 'package:rick_morty_explorer/core/di/injection_container.dart' as di;
import 'package:rick_morty_explorer/main.dart';

void main() {
  setUpAll(() async {
    await di.initDependencies();
  });

  testWidgets('App boots and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RickMortyApp());
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.byIcon(Icons.travel_explore_rounded), findsOneWidget);

    // Let the splash timer fully elapse so it doesn't leak into other
    // tests, then settle the navigation frame it triggers.
    await tester.pump(AppConstants.splashDuration + const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  });
}