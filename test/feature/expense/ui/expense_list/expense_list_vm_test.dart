import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/expense_list/expense_list_vm.dart';

import '../../domain/usecase/expense_usecase_test.dart';

void main() {
  final repository = MockExpenseRepository();
  when(() => repository.fetchExpenseList()).thenAnswer((_) {
    return Future.value(ApiResult.success(data: [expense]));
  });
  final ExpenseUseCase useCase = ExpenseUseCase(repository: repository);
  late ExpenseListVm expenseListVm;
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    expenseListVm = ExpenseListVm(useCase: useCase);
  });

  tearDown(() {
    container.dispose();
  });

  group('ExpenseListVm', () {
    test('loadExpenseList should call fetchExpenseList and update isLoading',
        () async {
      await expenseListVm.inject(expense: [expense, expense]);
      expect(expenseListVm.isLoading, false);
      expect(expenseListVm.expenseList.first.amount, '10.0');
      expect(expenseListVm.expenseList.isNotEmpty, true);
    });
  });
}
