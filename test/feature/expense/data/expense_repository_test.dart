import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/core/datasource/local/local_db.dart';
import 'package:personal_expense_tracker/src/feature/expense/data/expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class MockLocalDb extends Mock implements LocalDb {}

class MockIsar extends Mock implements Isar {}

void main() {
  group('ExpenseRepository', () {
    late ExpenseRepository expenseRepository;
    late MockLocalDb mockLocalDb;
    late MockIsar isar;

    setUp(() {
      isar = MockIsar();
      mockLocalDb = MockLocalDb();
      mockLocalDb.initialise(isar: isar);
      expenseRepository = ExpenseRepository(database: mockLocalDb);
    });

    test('deleteExpense returns ApiResult<String>', () async {
      const expenseId = 1;
      late var expectedResult =
          const ApiResult<String>.success(data: 'Success');

      when(() => mockLocalDb.deleteExpense(expenseId: expenseId))
          .thenAnswer((_) async => expectedResult);
      final result =
          await expenseRepository.deleteExpense(expenseId: expenseId);
      expect(result, expectedResult);
    });

    test('saveAndUpdateExpense returns ApiResult<String>', () async {
      final expense = Expense(
        id: 1,
        amount: '10.0',
        date: DateTime.now().toString(),
        description: 'Description',
      );
      const expectedResult = ApiResult<String>.success(data: 'Success');
      when(() => mockLocalDb.saveAndUpdateExpense(expense: expense))
          .thenAnswer((_) async => expectedResult);
      final result =
          await expenseRepository.saveAndUpdateExpense(expense: expense);
      expect(result, expectedResult);
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

      when(() => mockLocalDb.getExpenses())
          .thenAnswer((_) async => expectedResult);
      final result = await expenseRepository.fetchExpenseList();
      expect(result, expectedResult);
    });
  });
}
