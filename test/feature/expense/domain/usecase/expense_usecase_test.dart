import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/core/common/usecase_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';

class MockExpenseRepository extends Mock implements IExpenseRepository {}

final expense = Expense(
  id: 1,
  description: 'Description',
  amount: '10.0',
  date: DateTime.now().toString(),
);

void main() {
  group('ExpenseUseCase', () {
    late ExpenseUseCase expenseUseCase;
    late MockExpenseRepository mockExpenseRepository;

    setUp(() {
      mockExpenseRepository = MockExpenseRepository();
      expenseUseCase = ExpenseUseCase(repository: mockExpenseRepository);
    });

    test('saveAndUpdateExpense returns UsecaseResult<String>', () async {
      const expectedResult = UsecaseResult.success(data: 'Success');
      when(() => mockExpenseRepository.saveAndUpdateExpense(expense: expense))
          .thenAnswer((_) async => const ApiResult.success(data: 'Success'));
      final result =
          await expenseUseCase.saveAndUpdateExpense(expense: expense);

      expect(result, expectedResult);
    });

    test('fetchExpenseList updates expenseList and filteredExpenseList',
        () async {
      final expectedExpenseList = [
        expense,
      ];
      final expectedFilteredExpenseList = expectedExpenseList.reversed.toList();

      when(() => mockExpenseRepository.fetchExpenseList()).thenAnswer(
          (_) async => ApiResult.success(data: expectedExpenseList));

      await expenseUseCase.fetchExpenseList();

      expect(expenseUseCase.expenseList, expectedExpenseList);
      expect(expenseUseCase.filteredExpenseList, expectedFilteredExpenseList);
    });

    test(
        'deleteExpense removes the correct expense from expenseList and filteredExpenseList',
        () async {
      final expectedExpenseList = [];
      final expectedFilteredExpenseList = expectedExpenseList.reversed.toList();

      expenseUseCase.expenseList = [expense];
      expenseUseCase.filteredExpenseList = [expense];

      when(() => mockExpenseRepository.deleteExpense(expenseId: expense.id!))
          .thenAnswer((_) async => const ApiResult.success(data: 'Success'));

      final result = await expenseUseCase.deleteExpense(expenseId: expense.id!);

      expect(result, const UsecaseResult.success(data: 'Success'));
      expect(expenseUseCase.expenseList, expectedExpenseList);
      expect(expenseUseCase.filteredExpenseList, expectedFilteredExpenseList);
    });

    test('filterByDate filters the expenseList by date', () {
      final date = DateTime.now();
      final expectedExpenseList = [
        expense,
      ];
      final expectedFilteredExpenseList = expectedExpenseList.reversed.toList();

      expenseUseCase.expenseList = [
        expense,
      ];
      expenseUseCase.filteredExpenseList = [
        expense,
      ];

      expenseUseCase.filterByDate(date: date);

      expect(expenseUseCase.expenseList, expectedExpenseList);
      expect(expenseUseCase.filteredExpenseList, expectedFilteredExpenseList);
    });

    test('clearFilter clears the filteredExpenseList', () {
      final expectedExpenseList = [
        expense,
      ];
      final expectedFilteredExpenseList = expectedExpenseList.reversed.toList();
      expenseUseCase.clearFilter();
    });
  });
}
