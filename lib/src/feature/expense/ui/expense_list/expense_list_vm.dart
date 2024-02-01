import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/src/core/util/flutter_toast.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/add_expense/add_expense_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_screen.dart';

final expenseListVmProvider =
    ChangeNotifierProvider.autoDispose<ExpenseListVm>((ref) {
  return ExpenseListVm();
});

class ExpenseListVm extends ChangeNotifier {
  late ExpenseUseCase _useCase;
  bool isLoading = false;
  List<Expense> get expenseList => _useCase.filteredExpenseList;

  ExpenseListVm({ExpenseUseCase? useCase}) {
    _useCase = useCase ?? ExpenseUseCase();
    loadExpenseList();
  }

  Future<void> loadExpenseList() async {
    isLoading = true;
    notifyListeners();
    await _useCase.fetchExpenseList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> inject({required List<Expense> expense}) async {
    isLoading = true;
    notifyListeners();
    await _useCase.inject(expense: expense);
    isLoading = false;
    notifyListeners();
  }

  Future<void> onEditExpense(Expense expense, BuildContext context) async {
    final value =
        await context.pushNamed(AddExpenseScreen.route, extra: expense);
    if (value != null) {
      loadExpenseList();
    }
  }

  Future<void> onAddExpense(BuildContext context) async {
    final value = await context.pushNamed(AddExpenseScreen.route);
    if (value != null) {
      loadExpenseList();
    }
  }

  Future<void> onDeleteExpense(Expense expense, BuildContext context) async {
    final result = await _useCase.deleteExpense(expenseId: expense.id!);
    result.when(success: (success) {
      FlutterToast.show(message: success!);
      notifyListeners();
    }, failure: (failure) {
      FlutterToast.show(message: failure!);
    });
  }

  void filterByDate(DateTime? value) {
    if (value != null) {
      _useCase.filterByDate(date: value);
      notifyListeners();
    }
  }

  void clearFilter() {
    _useCase.clearFilter();
    notifyListeners();
  }

  void onViewSummary(BuildContext context) {
    context.pushNamed(ViewSummaryScreen.route);
  }
}
