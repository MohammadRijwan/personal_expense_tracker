import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

abstract class IExpenseRepository {
  Future<ApiResult<List<Expense>>> fetchExpenseList();
  Future<ApiResult<String>> saveAndUpdateExpense({required Expense expense});
  Future<ApiResult<String>> deleteExpense({required int expenseId});
}
