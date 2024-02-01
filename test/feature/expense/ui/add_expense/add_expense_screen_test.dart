import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/add_expense/add_expense_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/add_expense/add_expense_vm.dart';

import '../../../extensions.dart';
import '../../domain/interface/i_expense_repository_test.dart';

void main() {
  Size screenUtilSize = const Size(360, 690);
  var expenseModel = Expense(
      description: 'description',
      amount: '10.0',
      date: DateTime.now().toString());

  final expenseRepository = MockExpenseRepository();
  when(() => expenseRepository.fetchExpenseList()).thenAnswer((_) {
    return Future.value(ApiResult.success(data: [expenseModel]));
  });

  final providerOverrides = [
    addExpenseVmProvider.overrideWithProvider(
      (ref) => ChangeNotifierProvider.autoDispose<AddExpenseVm>(
        (ref) => AddExpenseVm(
            expenseModel: expenseModel,
            useCase: ExpenseUseCase(repository: expenseRepository)),
      ),
    ),
  ];

  testWidgets('AddExpenseScreen should render correctly',
      (WidgetTester tester) async {
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
                return AddExpenseScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('AddExpenseScreen should update expenseModel when provided',
      (WidgetTester tester) async {
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
                return AddExpenseScreen(expenseModel: expenseModel);
              }),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'description'), findsOneWidget);
    expect(find.widgetWithText(TextField, '10.0'), findsOneWidget);
    expect(find.text('Update Expense'), findsOneWidget);
  });
}
