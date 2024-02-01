import 'package:get_it/get_it.dart';
import 'package:personal_expense_tracker/src/core/datasource/local/local_db.dart';
import 'package:personal_expense_tracker/src/feature/expense/data/expense_repository.dart';

void setupDependencies() {
  final database = GetIt.instance.registerSingleton<LocalDb>(LocalDb.instance);
  GetIt.instance.registerSingleton<ExpenseRepository>(ExpenseRepository(
    database: database,
  ));
}
