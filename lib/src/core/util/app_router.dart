import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_expense_tracker/splash_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/add_expense/add_expense_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/expense_list/expense_list_screen.dart';
import 'package:personal_expense_tracker/src/feature/expense/ui/view_summary/view_summary_screen.dart';

class AppRoute {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: SplashScreen.route,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: ExpenseListScreen.route,
              name: ExpenseListScreen.route,
              builder: (BuildContext context, GoRouterState state) =>
                  ExpenseListScreen(),
            ),
            GoRoute(
              path: AddExpenseScreen.route,
              name: AddExpenseScreen.route,
              builder: (BuildContext context, GoRouterState state) =>
                  AddExpenseScreen(
                expenseModel: state.extra as Expense?,
              ),
            ),
            GoRoute(
              path: ViewSummaryScreen.route,
              name: ViewSummaryScreen.route,
              builder: (BuildContext context, GoRouterState state) =>
                  ViewSummaryScreen(),
            ),
          ]),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        RouteErrorScreen(
            title: 'Route Not Found',
            message: 'Error! The route ${state.error} not found.'),
  );

  static GoRouter get router => _router;
}

class RouteErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const RouteErrorScreen(
      {super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
