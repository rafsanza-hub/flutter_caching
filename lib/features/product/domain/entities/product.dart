import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final List<String> tags;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.tags,
  });

  @override
  List<Object?> get props =>
      [id, title, description, dueDate, priority, status, tags];
}
