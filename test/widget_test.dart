import 'package:bonus_tracker_app/core/widgets/app_button.dart';
import 'package:bonus_tracker_app/features/member_profile/widgets/add_mohsen_dialog.dart';
import 'package:bonus_tracker_app/features/member_profile/widgets/mohsen_history_bottom_sheet.dart';
import 'package:bonus_tracker_app/features/member_profile/widgets/mohsen_warning_summary_row.dart';
import 'package:bonus_tracker_app/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('renders button text and triggers onPressed on tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.text('Click Me'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: 'Loading...',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('renders outlined button correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.outlined(
              text: 'Outlined Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
    });
  });

  group('Mohsen & Warning History BottomSheet Tests', () {
    testWidgets('tapping Mohsens box opens history bottom sheet with items, edit, and delete icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MohsenWarningSummaryRow(
              mohsensCount: 8,
              warningsCount: 0,
              committeeId: 'preview_committee',
              memberId: 'preview_member',
            ),
          ),
        ),
      );

      expect(find.text('Mohsens'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('Warnings'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // Tap on Mohsens box
      await tester.tap(find.text('Mohsens'));
      await tester.pumpAndSettle();

      // History bottom sheet should be visible
      expect(find.byType(MohsenHistoryBottomSheet), findsOneWidget);
      expect(find.text('Mohsens'), findsAtLeastNWidgets(2)); // header and bottom footer
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.delete_outline), findsAtLeastNWidgets(1));

      // Tap on '+' button to open add dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Add dialog appears
      expect(find.text('Add Mohsen'), findsOneWidget);
      expect(find.text('Title *'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets(
        'AddMohsenDialog correctly calculates minAllowed on edit to prevent total < 0',
        (WidgetTester tester) async {
      final entry = MohsenEntryModel(
        id: 'entry_1',
        type: MohsenType.mohsen,
        title: 'Active in session',
        value: 2,
        reason: 'Active in session',
        addedBy: 'user_1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // currentTotal = 2, entry value = 2 => baseTotal = 0 => minAllowed must be 1
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AddMohsenDialog.show(
                    context,
                    isMohsen: true,
                    currentTotal: 2,
                    entry: entry,
                  );
                },
                child: const Text('Open Edit Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Edit Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Mohsen'), findsOneWidget);
      expect(find.text('+2'), findsOneWidget);

      // Decrement to +1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('+1'), findsOneWidget);

      // Tapping remove again should not decrement below 1 (cannot go to -1 since baseTotal is 0)
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets(
        'MohsenHistoryBottomSheet blocks delete with warning dialog if total would become negative',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  MohsenHistoryBottomSheet.show(
                    context,
                    isMohsen: true,
                    committeeId: 'comm_1',
                    memberId: 'mem_1',
                    // Sample entry has value = 1; set initialTotal to 0 so deleting would make total = -1
                    initialTotal: 0,
                  );
                },
                child: const Text('Open History'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open History'));
      await tester.pumpAndSettle();

      // Tap delete on the sample entry (value = 1, currentTotal = 0)
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // Blocked dialog should be visible explaining it cannot be deleted
      expect(find.text('Cannot Delete Mohsen'), findsOneWidget);
      expect(
        find.text(
            'This entry cannot be deleted because removing it would make the total negative.'),
        findsOneWidget,
      );

      // Tap OK to dismiss
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Cannot Delete Mohsen'), findsNothing);
    });
  });
}
