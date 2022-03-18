import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_provider_messager/src/widgets/dialogs/alert_dialog.dart';

void main() {
  group('Testing exceptions,', () {
    void _throwDummy(
      String name,
      void Function(Exception e) errorCallBack,
    ) {
      try {
        int.parse(name);
      } on FormatException catch (e) {
        errorCallBack(e);
      }
    }

    Future<void> _buildStatic(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
      final BuildContext context = tester.element(find.byType(Container));

      dummy(except) => showDialog(
          context: context,
          builder: (context) => ShowAlertDialog(e: except, title: 'tim'));

      _throwDummy('tim', (e) => dummy(e));
      await tester.pumpAndSettle();
    }

    testWidgets('test simple alert dialog', (WidgetTester tester) async {
      await _buildStatic(tester);
      expect(find.byKey(ShowAlertDialog.alertDialogKey), findsOneWidget);
    });

    testWidgets('test simple alert dialog, then close',
        (WidgetTester tester) async {
      await _buildStatic(tester);
      expect(find.byKey(ShowAlertDialog.alertDialogKey), findsOneWidget);

      await tester.tap(find.byKey(ShowAlertDialog.alertDialogAcceptButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(ShowAlertDialog.alertDialogKey), findsNothing);
    });
  });
}
