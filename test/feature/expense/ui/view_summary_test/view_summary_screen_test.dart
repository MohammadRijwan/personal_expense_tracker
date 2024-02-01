import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/summary_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_vm.dart';

import '../../../extensions.dart';
import '../../domain/interface/i_expense_repository_test.dart';
import '../add_expense/add_expense_vm_test.dart';

class MockViewSummaryVm extends Mock implements ViewSummaryVm {}

void main() {
  late MockViewSummaryVm mockVm;

  setUp(() {
    mockVm = MockViewSummaryVm();
  });

  Size screenUtilSize = const Size(360, 690);
  final expenseRepository = MockExpenseRepository();
  when(() => expenseRepository.fetchExpenseList()).thenAnswer((_) {
    return Future.value(ApiResult.success(data: [expenseModel]));
  });

  final repoEmpty = MockExpenseRepository();
  when(() => repoEmpty.fetchExpenseList()).thenAnswer((_) {
    return Future.value(const ApiResult.success(data: []));
  });

  final providerOverrides = [
    viewSummaryVmProvider.overrideWith(
      (ref) => ViewSummaryVm(
        useCase: SummaryUseCase(repository: expenseRepository),
      ),
    ),
  ];

  testWidgets('ViewSummaryScreen should render correctly',
      (WidgetTester tester) async {
    when(() => mockVm.loadExpenseList()).thenAnswer((_) {});
    when(() => mockVm.isLoading).thenReturn(false);
    await tester.setScreenSize(width: 360, height: 690);
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: providerOverrides,
          child: ScreenUtilInit(
              designSize: screenUtilSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? child) {
                return ViewSummaryScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('View Summary'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.byType(MonthlyData), findsOneWidget);
    expect(find.byType(WeeklyData), findsNothing);
  });
}
