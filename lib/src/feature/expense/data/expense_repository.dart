import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/core/datasource/local/local_db.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class ExpenseRepository extends IExpenseRepository {
  late LocalDb _localDb;
  ExpenseRepository({LocalDb? database}) {
    _localDb = database ?? LocalDb.instance;
  }
  @override
  Future<ApiResult<String>> deleteExpense({required int expenseId}) async {
    return _localDb.deleteExpense(expenseId: expenseId);
  }

  @override
  Future<ApiResult<String>> saveAndUpdateExpense(
      {required Expense expense}) async {
    return _localDb.saveAndUpdateExpense(expense: expense);
  }

  @override
  Future<ApiResult<List<Expense>>> fetchExpenseList() {
    return _localDb.getExpenses();
  }
}
