import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/summary_usecase.dart';

class MockExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  late SummaryUseCase summaryUseCase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    summaryUseCase = SummaryUseCase(repository: mockRepository);
  });

  group('SummaryUseCase', () {
    test('fetchExpenseList should fetch expenses from repository', () async {
      final expenses = [
        Expense(
            date: DateTime(2022, 1, 1).toString(),
            amount: '100',
            description: 'description'),
        Expense(
            date: DateTime(2022, 1, 2).toString(),
            amount: '200',
            description: 'description'),
      ];
      when(() => mockRepository.fetchExpenseList())
          .thenAnswer((_) async => ApiResult.success(data: expenses));
      await summaryUseCase.fetchExpenseList();
      expect(summaryUseCase.expenseList, equals(expenses));
    });

    test('filterByMonth should filter expenses by month', () {
      final expenses = [
        Expense(
            date: DateTime(2022, 1, 1).toString(),
            amount: '100',
            description: 'description'),
        Expense(
            date: DateTime(2022, 2, 1).toString(),
            amount: '200',
            description: 'description'),
        Expense(
            date: DateTime(2022, 1, 15).toString(),
            amount: '150',
            description: 'description'),
      ];
      summaryUseCase.expenseList = expenses;
      summaryUseCase.filterByMonth(date: DateTime(2022, 1, 1));

      expect(summaryUseCase.filteredExpenseList.length, equals(2));
      expect(DateTime.parse(summaryUseCase.filteredExpenseList[0].date).month,
          equals(1));
      expect(DateTime.parse(summaryUseCase.filteredExpenseList[1].date).month,
          equals(1));
    });

    test('filterByWeek should filter expenses by week', () {
      final expenses = [
        Expense(
            date: DateTime(2022, 1, 1).toString(),
            amount: '100',
            description: 'description'),
        Expense(
            date: DateTime(2022, 1, 8).toString(),
            amount: '200',
            description: 'description'),
        Expense(
            date: DateTime(2022, 1, 15).toString(),
            amount: '150',
            description: 'description'),
      ];
      summaryUseCase.expenseList = expenses;
      summaryUseCase.filterByWeek(date: DateTime(2022, 1, 1));

      expect(summaryUseCase.expenseWeeklyList.length, equals(3));
      expect(summaryUseCase.weeklyData.length, equals(3));
      expect(summaryUseCase.weeklyData[1]?.length, equals(1));
      expect(summaryUseCase.weeklyData[2]?.length, equals(1));
    });
  });
}
