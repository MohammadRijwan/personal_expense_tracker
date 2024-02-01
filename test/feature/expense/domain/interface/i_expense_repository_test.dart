import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class MockExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  group('IExpenseRepository', () {
    late IExpenseRepository expenseRepository;

    setUp(() {
      expenseRepository = MockExpenseRepository();
    });

    test('fetchExpenseList returns ApiResult<List<Expense>>', () async {
      final expectedResult = ApiResult<List<Expense>>.success(data: [
        Expense(
          id: 1,
          description: 'Description',
          amount: '10.0',
          date: DateTime.now().toString(),
        ),
      ]);

      when(() => expenseRepository.fetchExpenseList()).thenAnswer(
        (_) async => expectedResult,
      );
      final result = await expenseRepository.fetchExpenseList();
      expect(result, expectedResult);
    });

    test('saveAndUpdateExpense returns ApiResult<String>', () async {
      final expense = Expense(
        id: 1,
        description: 'Description',
        amount: '10.0',
        date: DateTime.now().toString(),
      );
      const expectedResult = ApiResult<String>.success(data: 'Success');

      when(() => expenseRepository.saveAndUpdateExpense(expense: expense))
          .thenAnswer((_) async => expectedResult);

      final result =
          await expenseRepository.saveAndUpdateExpense(expense: expense);

      expect(result, expectedResult);
    });

    test('deleteExpense returns ApiResult<String>', () async {
      const expenseId = 1;
      const expectedResult = ApiResult<String>.success(data: 'Success');
      when(() => expenseRepository.deleteExpense(expenseId: expenseId))
          .thenAnswer((_) async => expectedResult);
      final result =
          await expenseRepository.deleteExpense(expenseId: expenseId);
      expect(result, expectedResult);
    });
  });
}
