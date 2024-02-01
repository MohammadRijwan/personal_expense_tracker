import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/summary_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_vm.dart';

import '../../domain/usecase/expense_usecase_test.dart';
import '../add_expense/add_expense_vm_test.dart';

Future<void> main() async {
  final repository = MockExpenseRepository();
  when(() => repository.fetchExpenseList()).thenAnswer((_) {
    return Future.value(ApiResult.success(data: [expenseModel]));
  });
  final SummaryUseCase useCase = SummaryUseCase(repository: repository);
  group('ViewSummaryVm', () {
    late ProviderContainer container;
    late ViewSummaryVm viewSummaryVm;

    setUp(() {
      container = ProviderContainer();
      viewSummaryVm = ViewSummaryVm(useCase: useCase);
    });

    tearDown(() {
      container.dispose();
    });
    test(
        'loadExpenseList should fetch expense list and calculate total expense',
        () async {
      await viewSummaryVm.inject(filteredExpenseList: [expense, expense]);
      expect(viewSummaryVm.isLoading, false);
      expect(viewSummaryVm.totalExpense, greaterThan(0));
      expect(viewSummaryVm.expenseMonthlyList.isNotEmpty, true);
    });
  });
}
