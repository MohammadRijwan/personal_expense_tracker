import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/expense_list/expense_list_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/expense_list/expense_list_vm.dart';

import '../../../extensions.dart';
import '../../domain/interface/i_expense_repository_test.dart';

class MockExpenseVm extends Mock implements ExpenseListVm {}

class MockExpenseUseCase extends Mock implements ExpenseUseCase {}

void main() {
  late MockExpenseVm mockVm;
  late MockExpenseUseCase mockExpenseUseCase;

  Size screenUtilSize = const Size(360, 690);
  var expenseModel = Expense(
    description: 'description',
    amount: '10.0',
    date: DateTime.now().toString(),
  );
  final expenseRepository = MockExpenseRepository();
  when(() => expenseRepository.fetchExpenseList()).thenAnswer((_) {
    return Future.value(ApiResult.success(data: [expenseModel]));
  });

  final repoEmpty = MockExpenseRepository();
  when(() => repoEmpty.fetchExpenseList()).thenAnswer((_) {
    return Future.value(const ApiResult.success(data: []));
  });

  final providerOverrides = [
    expenseListVmProvider.overrideWith(
      (ref) => ExpenseListVm(
        useCase: ExpenseUseCase(repository: expenseRepository),
      ),
    ),
  ];

  setUp(() {
    mockExpenseUseCase = MockExpenseUseCase();
    mockVm = MockExpenseVm();
  });

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
                return ExpenseListScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Personal Expense App'), findsOneWidget);
  });

  testWidgets('should display "No Expense Available" when expenseList is empty',
      (WidgetTester tester) async {
    when(() => mockVm.isLoading).thenReturn(false);
    when(() => mockVm.expenseList).thenReturn([]);
    await tester.setScreenSize(width: 360, height: 690);
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            expenseListVmProvider.overrideWith((ref) => ExpenseListVm(
                  useCase: ExpenseUseCase(repository: repoEmpty),
                ))
          ],
          child: ScreenUtilInit(
              designSize: screenUtilSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (BuildContext context, Widget? child) {
                return ExpenseListScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No Expense Available'), findsOneWidget);
  });

  testWidgets('should display expense details when expenseList is not empty',
      (WidgetTester tester) async {
    when(() => mockVm.isLoading).thenReturn(false);
    when(() => mockVm.expenseList).thenReturn([expenseModel]);
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
                return ExpenseListScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump();
    expect(find.text('Amount: ${expenseModel.amount}'), findsOneWidget);
    expect(
        find.text('Description: ${expenseModel.description}'), findsOneWidget);
    expect(
        find.text(
            'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(expenseModel.date))}'),
        findsOneWidget);
  });

  testWidgets(
      'should show delete confirmation dialog when delete icon is tapped',
      (WidgetTester tester) async {
    when(() => mockVm.isLoading).thenReturn(false);
    when(() => mockVm.expenseList).thenReturn([expenseModel]);
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
                return ExpenseListScreen();
              }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_forever_outlined));
    await tester.pump();
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Are you sure you want to delete this expense?'),
        findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });
}
