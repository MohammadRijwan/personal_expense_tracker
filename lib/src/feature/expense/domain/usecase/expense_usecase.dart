import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/core/common/usecase_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/data/expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class ExpenseUseCase {
  List<Expense> expenseList = [];
  List<Expense> filteredExpenseList = [];
  late IExpenseRepository _repository;
  ExpenseUseCase({IExpenseRepository? repository}) {
    _repository = repository ?? GetIt.instance.get<ExpenseRepository>();
  }

  ///saveAndUpdateExpense
  Future<UsecaseResult<String>> saveAndUpdateExpense(
      {required Expense expense}) async {
    UsecaseResult<String> useCaseResult =
        const UsecaseResult.failure(error: 'Something went wrong');
    ApiResult result = await _repository.saveAndUpdateExpense(expense: expense);
    result.when(success: (success) {
      useCaseResult = UsecaseResult.success(data: success!);
    }, failure: (failure) {
      useCaseResult =
          const UsecaseResult.failure(error: 'Something went wrong');
    });
    return useCaseResult;
  }

  ///fetchExpenseList
  Future<void> fetchExpenseList() async {
    ApiResult result = await _repository.fetchExpenseList();
    result.when(success: (success) {
      expenseList = success;
    }, failure: (failure) {
      expenseList = [];
    });
    filteredExpenseList = expenseList.reversed.toList();
  }

  Future<void> inject({required List<Expense> expense}) async {
    expenseList = expense;
    filteredExpenseList = expenseList.reversed.toList();
  }

  ///deleteExpense
  Future<UsecaseResult<String>> deleteExpense({required int expenseId}) async {
    UsecaseResult<String> useCaseResult =
        const UsecaseResult.failure(error: 'Something went wrong');
    ApiResult result = await _repository.deleteExpense(expenseId: expenseId);
    result.when(success: (success) {
      expenseList.removeWhere((element) => element.id == expenseId);
      filteredExpenseList.removeWhere((element) => element.id == expenseId);
      useCaseResult = UsecaseResult.success(data: success!);
    }, failure: (failure) {
      useCaseResult =
          const UsecaseResult.failure(error: 'Something went wrong');
    });
    return useCaseResult;
  }

  void filterByDate({required DateTime date}) {
    String filterDate = DateFormat('dd-MM-yyyy').format(date);
    log('filterByDate::$date');
    filteredExpenseList = expenseList
        .where((element) => element.getDate() == filterDate)
        .toList();
  }

  void clearFilter() {
    filteredExpenseList = expenseList.reversed.toList();
  }
}
