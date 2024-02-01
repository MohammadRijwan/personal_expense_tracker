import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/src/core/widget/text_widget.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/expense_list/expense_list_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String route = "/";
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    load(context);
  }

  Future<void> load(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      context.pushReplacementNamed(ExpenseListScreen.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.track_changes_sharp,
                color: Theme.of(context).primaryColorDark,
                size: 100.sp,
              ),
              TextWidget(
                'Welcome to the Personal\nExpense Tracker App',
                fontSize: 18.sp,
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(
                height: 20.sp,
              ),
              TextWidget(
                'A mobile application for users to track and manage personal expenses.',
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                color: Theme.of(context).hintColor,
              )
            ],
          ),
        ),
      )),
    );
  }
}
