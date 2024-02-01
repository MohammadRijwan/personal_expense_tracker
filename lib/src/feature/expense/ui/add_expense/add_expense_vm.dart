import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/src/core/util/flutter_toast.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';

final addExpenseVmProvider = ChangeNotifierProvider.family
    .autoDispose<AddExpenseVm, Expense?>((ref, expenseModel) {
  return AddExpenseVm(expenseModel: expenseModel);
});

class AddExpenseVm extends ChangeNotifier {
  late ExpenseUseCase _useCase;
  final Expense? expenseModel;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  AddExpenseVm({this.expenseModel, ExpenseUseCase? useCase}) {
    _useCase = useCase ?? ExpenseUseCase();
    loadData();
  }

  loadData() {
    if (expenseModel != null) {
      amountController.text = expenseModel!.amount;
      descriptionController.text = expenseModel!.description;
      selectedDate = DateTime.parse(expenseModel!.date);
    }
  }

  void onDateChange(DateTime? date) {
    selectedDate = date!;
  }

  Future<void> onSave(BuildContext context) async {
    Expense expense = Expense(
      id: expenseModel?.id,
      description: descriptionController.text,
      amount: amountController.text,
      date: selectedDate.toString(),
    );
    final result = await _useCase.saveAndUpdateExpense(expense: expense);
    result.when(success: (success) {
      context.pop(true);
      FlutterToast.show(message: success!);
    }, failure: (failure) {
      FlutterToast.show(message: failure!);
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
