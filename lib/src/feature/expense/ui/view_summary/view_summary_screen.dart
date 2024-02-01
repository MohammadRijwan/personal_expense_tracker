import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:personal_expense_tracker/src/core/widget/text_widget.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_vm.dart';

class ViewSummaryScreen extends StatelessWidget {
  static const String route = "view_summary_screen";
  ViewSummaryScreen({super.key});
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final vm = ref.watch(viewSummaryVmProvider);
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorLight,
            title: TextWidget(
              'View Summary',
              fontSize: 16.sp,
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w900,
            ),
            centerTitle: true,
            bottom: const TabBar(tabs: [
              TextWidget(
                'Monthly',
              ),
              TextWidget(
                'Weekly',
              )
            ]),
          ),
          body: TabBarView(
            children: [
              MonthlyData(
                vm: vm,
              ),
              WeeklyData(
                vm: vm,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class MonthlyData extends StatelessWidget {
  final ViewSummaryVm vm;
  const MonthlyData({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: vm.isLoading
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
                          onPressed: () async {
                            final selected = await showMonthYearPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2050),
                            );
                            if (selected != null) {
                              vm.filterByMonth(selected);
                            }
                          },
                          icon: Row(
                            children: [
                              TextWidget(
                                'Select Month',
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.expenseMonthlyList.isEmpty
                      ? Center(
                          child: TextWidget(
                            'No Expense Available',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: vm.expenseMonthlyList.length,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 60.h),
                                itemBuilder: (context, index) {
                                  Expense expense =
                                      vm.expenseMonthlyList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surface
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  'Date: ${expense.getDate()}',
                                                  fontSize: 12.sp,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                TextWidget(
                                                  expense.amount,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.h),
                                            TextWidget(
                                              'Description: ${expense.description}',
                                              fontSize: 12.sp,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(height: 5.h),
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextWidget(
                                'Total Expense: ${vm.totalExpense}',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            )
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

class WeeklyData extends StatelessWidget {
  final ViewSummaryVm vm;
  const WeeklyData({super.key, required this.vm});
  @override
  Widget build(BuildContext context) {
    return vm.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
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
                        onPressed: () async {
                          final selected = await showMonthYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2050),
                          );
                          if (selected != null) {
                            vm.filterByWeek(selected);
                          }
                        },
                        icon: Row(
                          children: [
                            TextWidget(
                              'Select Month',
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              vm.expenseMonthlyList.isEmpty
                  ? Center(
                      child: TextWidget(
                        'No Expense Available',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: vm.expenseWeeklyList.keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int weekKey =
                              vm.expenseWeeklyList.keys.elementAt(index);
                          int totalAmount = vm.expenseWeeklyList[weekKey]!.fold(
                              0, (sum, item) => sum + int.parse(item.amount));

                          return Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.4)
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(children: [
                                TextWidget(
                                  'Week $weekKey',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        vm.expenseWeeklyList[weekKey]!.length,
                                    itemBuilder: (context, index) {
                                      Expense expense =
                                          vm.expenseWeeklyList[weekKey]![index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                    'Date: ${expense.getDate()}',
                                                    fontSize: 12.sp,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                  TextWidget(
                                                    expense.amount,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2.h),
                                              TextWidget(
                                                'Description: ${expense.description}',
                                                fontSize: 12.sp,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(height: 5.h),
                                            ]),
                                      );
                                    }),
                                TextWidget(
                                  'Total Amount: $totalAmount',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
  }
}
