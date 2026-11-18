import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:falah_app/main.dart';
import 'package:falah_app/models/app_models.dart';
import 'package:falah_app/services/app_state.dart';

void main() {
  testWidgets('Home counts use the same status model as stored lands', (tester) async {
    AppState().setTabIndex(0);
    await tester.pumpWidget(const FalahApp());
    expect(find.text('كل أرض، بداية خير.'), findsOneWidget);
    for (final status in LandReviewStatus.values) {
      expect(find.text(status.label), findsWidgets);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Services navigation reaches the land register', (tester) async {
    AppState().setTabIndex(2);
    await tester.pumpWidget(const FalahApp());
    expect(find.text('كيف نقدر نساعدك؟'), findsOneWidget);
    await tester.tap(find.text('سجل الأراضي'));
    await tester.pumpAndSettle();
    expect(AppState().currentTabIndex, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home supports a narrow screen and larger text', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    AppState().setTabIndex(0);
    await tester.pumpWidget(const FalahApp());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
