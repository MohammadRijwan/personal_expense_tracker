import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/src/feature/expense/domain/model/expense.dart';

void main() {
  group('Expense', () {
    const id = 1;
    const description = 'Description';
    const amount = 10.0;
    const date = '2022-01-01';

    test('fromJson creates an Expense object from a JSON map', () {
      final json = {
        'amount': amount.toString(),
        'description': description,
        'id': id,
        'date': date,
      };
      const isarId = 1;

      final expense = Expense.fromJson(json, isarId);

      expect(expense.id, isarId);
      expect(expense.description, description);
      expect(expense.amount, amount.toStringAsFixed(1));
      expect(expense.date, date);
    });

    test('toJson returns a JSON map from an Expense object', () {
      final expense = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final json = expense.toJson();

      expect(json['id'], id);
      expect(json['description'], description);
      expect(json['amount'], amount.toStringAsFixed(2));
      expect(json['date'], date);
    });

    test('getDate returns the correct date string', () {
      final expense = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final dateString = expense.getDate();

      expect(dateString, '01-01-2022');
    });

    test('getMonth returns the correct month string', () {
      final expense = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final monthString = expense.getMonth();

      expect(monthString, '01-2022');
    });

    test('getDateWithFormat returns the correct date string with format', () {
      final expense = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final dateString = expense.getDateWithFormat();

      expect(dateString, '01-01-2022');
    });

    test('operator == returns true when objects have the same id', () {
      final expense1 = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );
      final expense2 = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final result = expense1 == expense2;

      expect(result, true);
    });

    test('operator == returns false when objects have different ids', () {
      final expense1 = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );
      final expense2 = Expense(
        id: id + 1,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final result = expense1 == expense2;

      expect(result, false);
    });

    test('hashCode returns the same value for objects with the same id', () {
      final expense1 = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );
      final expense2 = Expense(
        id: id,
        description: description,
        amount: amount.toStringAsFixed(2),
        date: date,
      );

      final hashCode1 = expense1.hashCode;
      final hashCode2 = expense2.hashCode;

      expect(hashCode1, hashCode2);
    });
  });
}
