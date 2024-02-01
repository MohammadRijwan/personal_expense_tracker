import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/summary_usecase.dart';

final viewSummaryVmProvider =
    ChangeNotifierProvider.autoDispose<ViewSummaryVm>((ref) {
  return ViewSummaryVm();
});

class ViewSummaryVm extends ChangeNotifier {
  late SummaryUseCase _useCase;
  bool isLoading = false;
  List<Expense> get expenseMonthlyList => _useCase.filteredExpenseList;
  Map<int, List<Expense>> get expenseWeeklyList => _useCase.weeklyData;
  ViewSummaryVm({SummaryUseCase? useCase}) {
    _useCase = useCase ?? SummaryUseCase();
    loadExpenseList();
  }

  loadExpenseList() async {
    isLoading = true;
    notifyListeners();
    await _useCase.fetchExpenseList();
    for (var element in _useCase.filteredExpenseList) {
      totalExpense = totalExpense + double.parse(element.amount);
    }
    isLoading = false;
    notifyListeners();
  }

  inject({required List<Expense> filteredExpenseList}) async {
    isLoading = true;
    notifyListeners();
    await _useCase.inject(expense: filteredExpenseList);
    for (var element in filteredExpenseList) {
      totalExpense = totalExpense + double.parse(element.amount);
    }
    isLoading = false;
    notifyListeners();
  }

  double totalExpense = 0;
  void filterByMonth(DateTime? value) {
    totalExpense = 0;
    if (value != null) {
      _useCase.filterByMonth(date: value);
      for (var element in _useCase.filteredExpenseList) {
        totalExpense = totalExpense + double.parse(element.amount);
      }
      notifyListeners();
    }
  }

  void filterByWeek(DateTime? value) {
    totalExpense = 0;
    if (value != null) {
      _useCase.filterByWeek(date: value);
      for (var element in _useCase.filteredExpenseList) {
        totalExpense = totalExpense + double.parse(element.amount);
      }
      notifyListeners();
    }
  }
}
