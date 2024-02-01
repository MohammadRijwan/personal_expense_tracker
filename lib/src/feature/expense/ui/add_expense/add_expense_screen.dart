import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:personal_expense_tracker/src/core/widget/text_widget.dart';
import 'package:personal_expense_tracker/src/core/widget/textfield_widget.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

import 'add_expense_vm.dart';

class AddExpenseScreen extends StatelessWidget {
  final Expense? expenseModel;
  static const String route = "add_expense_screen";
  AddExpenseScreen({super.key, this.expenseModel});

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final _vm = ref.watch(addExpenseVmProvider(expenseModel));
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: TextWidget(
            expenseModel != null ? 'Update Expense' : 'Add Expense',
            fontSize: 16.sp,
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w900,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                TextFieldWidget(
                  labelText: 'Amount',
                  controller: _vm.amountController,
                  name: 'amount',
                  onChange: (val) {
                    formKey.currentState!.fields['amount']!.validate();
                  },
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: FormBuilderDateTimePicker(
                    name: 'date',
                    initialValue: _vm.selectedDate,
                    inputType: InputType.date,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    decoration: InputDecoration(
                      hintText: 'Date',
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    onChanged: (date) {
                      _vm.onDateChange(date);
                    },
                  ),
                ),
                TextFieldWidget(
                  labelText: 'Description',
                  maxLine: 5,
                  controller: _vm.descriptionController,
                  name: 'description',
                  onChange: (val) {
                    formKey.currentState!.fields['description']!.validate();
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(height: 20.sp),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.saveAndValidate()) {
                      FocusScope.of(context).unfocus();
                      _vm.onSave(context);
                    }
                  },
                  child: TextWidget(
                    'Save',
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
