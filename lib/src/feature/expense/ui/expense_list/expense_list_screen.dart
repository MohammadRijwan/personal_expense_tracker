import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_expense_tracker/src/core/widget/text_widget.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

import 'expense_list_vm.dart';

class ExpenseListScreen extends StatelessWidget {
  static const String route = "expense_list_screen";
  ExpenseListScreen({super.key});
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final _vm = ref.watch(expenseListVmProvider);
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: TextWidget(
            'Personal Expense App',
            fontSize: 16.sp,
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w900,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  _vm.onViewSummary(context);
                },
                icon: Icon(
                  Icons.view_kanban_rounded,
                  color: Theme.of(context).primaryColorDark,
                  size: 35,
                )),
          ],
        ),
        body: SafeArea(
          child: _vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          TextWidget(
                            'Filter:',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2150),
                                  initialDate: DateTime.now(),
                                ).then((value) {
                                  _vm.filterByDate(value);
                                });
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColorDark,
                              )),
                          IconButton(
                              onPressed: () {
                                _vm.clearFilter();
                              },
                              icon: Icon(
                                Icons.filter_alt_off_rounded,
                                color: Theme.of(context).primaryColorDark,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _vm.expenseList.isEmpty
                          ? Center(
                              child: TextWidget(
                                'No Expense Available',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _vm.expenseList.length,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 60.h),
                              itemBuilder: (context, index) {
                                Expense expense = _vm.expenseList[index];
                                return Container(
                                  margin: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextWidget(
                                                  'Amount: ${expense.amount}',
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _vm.onEditExpense(
                                                      expense, context);
                                                },
                                                child: Icon(
                                                  Icons.edit_note_rounded,
                                                  size: 25.sp,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.r),
                                                            ),
                                                            title: TextWidget(
                                                              'Delete',
                                                              fontSize: 14.sp,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            content: TextWidget(
                                                              'Are you sure you want to delete this expense?',
                                                              fontSize: 12.sp,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  _vm.onDeleteExpense(
                                                                      expense,
                                                                      context);
                                                                },
                                                                child:
                                                                    TextWidget(
                                                                  'Yes',
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                              TextButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    TextWidget(
                                                                  'No',
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface,
                                                                ),
                                                              )
                                                            ]);
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.delete_forever_outlined,
                                                  size: 25.sp,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          TextWidget(
                                            'Description: ${expense.description}',
                                            fontSize: 12.sp,
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(height: 5.h),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextWidget(
                                              'Date: ${expense.getDate()}',
                                              fontSize: 12.sp,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ]),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.surface,
            size: 35,
          ),
          onPressed: () {
            _vm.onAddExpense(context);
          },
        ),
      );
    });
  }
}
