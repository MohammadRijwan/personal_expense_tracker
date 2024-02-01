import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_expense_tracker/src/core/common/usecase_result.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/usecase/expense_usecase.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/add_expense/add_expense_vm.dart';

class MockExpenseUseCase extends Mock implements ExpenseUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

final expenseModel = Expense(
  id: 1,
  description: 'Expense Description',
  amount: '100',
  date: '2022-01-01',
);

void main() {
  late AddExpenseVm addExpenseVm;
  late MockExpenseUseCase mockExpenseUseCase;

  setUp(() {
    mockExpenseUseCase = MockExpenseUseCase();
    addExpenseVm =
        AddExpenseVm(expenseModel: expenseModel, useCase: mockExpenseUseCase);
  });

  test('loadData should populate the text controllers and selected date', () {
    addExpenseVm.loadData();
    expect(addExpenseVm.amountController.text, expenseModel.amount);
    expect(addExpenseVm.descriptionController.text, expenseModel.description);
    expect(addExpenseVm.selectedDate, DateTime.parse(expenseModel.date));
  });

  test('onDateChange should update the selected date', () {
    final newDate = DateTime(2022, 02, 01);
    addExpenseVm.onDateChange(newDate);
    expect(addExpenseVm.selectedDate, newDate);
  });

  test('onSave should call saveAndUpdateExpense and show success message',
      () async {
    const result = UsecaseResult<String>.success(data: 'Expense saved');
    when(() => mockExpenseUseCase.saveAndUpdateExpense(expense: expenseModel))
        .thenAnswer((_) async => result);
    expect(const UsecaseResult<String>.success(data: 'Expense saved'), result);
  });

  test('onSave should call saveAndUpdateExpense and show failure message',
      () async {
    const result = UsecaseResult<String>.failure(error: 'Something went wrong');
    when(() => mockExpenseUseCase.saveAndUpdateExpense(expense: expenseModel))
        .thenAnswer((_) async => result);
    expect(const UsecaseResult<String>.failure(error: 'Something went wrong'),
        result);
  });
}
