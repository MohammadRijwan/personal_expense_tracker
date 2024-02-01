import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id? id;
  String description;
  String amount;
  String date;

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  getDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }

  getMonth() {
    return DateFormat('MM-yyyy').format(DateTime.parse(date));
  }

  getDateWithFormat() {
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    return formatter.format(DateTime.parse(date));
  }

  factory Expense.fromJson(
    Map json,
    int isarId,
  ) {
    return Expense(
      amount: json['amount'],
      description: json['description'],
      id: isarId,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'id': id,
        'date': date,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
