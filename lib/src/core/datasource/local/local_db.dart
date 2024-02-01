import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class LocalDb {
  Isar? isar;
  static LocalDb? _instance;

  String? loggedInUserId;

  LocalDb._() {
    initialise();
  }

  static LocalDb get instance {
    _instance ??= LocalDb._();
    return _instance!;
  }

  initialise({Isar? isar}) async {
    final dir = await getApplicationDocumentsDirectory();
    this.isar ??= isar ??
        await Isar.open(
          [
            ExpenseSchema,
          ],
          directory: dir.path,
          name: 'expenseDb',
        );
  }

  ///getExpenses

  Future<ApiResult<List<Expense>>> getExpenses() async {
    ApiResult<List<Expense>> result = const ApiResult.failure(
        message: 'Something went wrong please try again.');

    List<Expense> expenses = [];
    try {
      await isar!.txn(() async {
        expenses = await isar!.expenses.where().findAll();
      });
      if (expenses.isNotEmpty) {
        result = ApiResult.success(data: expenses);
      } else {
        result = const ApiResult.success(data: []);
      }
    } catch (e) {
      result = const ApiResult.failure(
          message: 'Something went wrong please try again.');
    }
    return result;
  }

  Future<ApiResult<String>> saveAndUpdateExpense({
    required Expense expense,
  }) async {
    ApiResult<String> result =
        const ApiResult.failure(message: 'Something went wrong');
    await isar!.writeTxn(() async {
      try {
        await isar!.expenses.put(expense);
        result = const ApiResult.success(data: 'Successfully Saved');
      } catch (e, stack) {
        log(e.toString());
        log(stack.toString());
        result = const ApiResult.failure(message: 'Something went wrong');
      }
    });
    return result;
  }

  Future<ApiResult<String>> deleteExpense({required int expenseId}) async {
    ApiResult<String> result =
        const ApiResult.failure(message: 'Something went wrong');
    await isar!.writeTxn(() async {
      try {
        await isar!.expenses.delete(expenseId);
        result = const ApiResult.success(data: 'Successfully Deleted');
      } catch (e, stack) {
        log(e.toString());
        log(stack.toString());
        result = const ApiResult.failure(message: 'Something went wrong');
      }
    });
    return result;
  }
}
