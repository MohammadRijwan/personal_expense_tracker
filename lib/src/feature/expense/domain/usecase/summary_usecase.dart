import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/src/core/common/api_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/data/expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/interface/i_expense_repository.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

class SummaryUseCase {
  List<Expense> expenseList = [];
  List<Expense> filteredExpenseList = [];
  List<Expense> expenseWeeklyList = [];
  Map<int, List<Expense>> weeklyData = {};
  late IExpenseRepository _repository;
  SummaryUseCase({IExpenseRepository? repository}) {
    _repository = repository ?? GetIt.instance.get<ExpenseRepository>();
  }

  ///fetchExpenseList
  Future<void> fetchExpenseList() async {
    ApiResult result = await _repository.fetchExpenseList();
    result.when(success: (success) {
      expenseList = success;
    }, failure: (failure) {
      expenseList = [];
    });
    filterByMonth(date: DateTime.now());
    filterByWeek(date: DateTime.now());
  }

  Future<void> inject({required List<Expense> expense}) async {
    expenseList = expense;
    filterByMonth(date: DateTime.now());
    filterByWeek(date: DateTime.now());
  }

  void filterByMonth({required DateTime date}) {
    String filterDate = DateFormat('MM-yyyy').format(date);
    log('filterByMonth::$date');
    filteredExpenseList = expenseList
        .where((element) => element.getMonth() == filterDate)
        .toList();
    filteredExpenseList.sort((a, b) => a.date.compareTo(b.date));
  }

  void filterByWeek({required DateTime date}) {
    String filterDate = DateFormat('MM-yyyy').format(date);
    log('filterByWeek::$date');
    expenseWeeklyList = expenseList
        .where((element) => element.getMonth() == filterDate)
        .toList();
    _getWeeklyData();
  }

  int _getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  _getWeeklyData() {
    weeklyData = {};
    expenseWeeklyList.sort((a, b) => a.date.compareTo(b.date));
    for (var data in expenseWeeklyList) {
      int weekOfYear = _getWeekNumber(DateTime.parse(data.date));
      if (weeklyData[weekOfYear] == null) {
        weeklyData[weekOfYear] = [data];
      } else {
        weeklyData[weekOfYear]?.add(data);
      }
    }
  }
}
