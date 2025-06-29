import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final String imageUrl;
  final List<String> tags;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.imageUrl,
    required this.tags,
  });

  @override
  List<Object?> get props =>
      [id, title, description, dueDate, priority, imageUrl, status, tags];
}
