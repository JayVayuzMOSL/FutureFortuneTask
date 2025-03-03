import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? id;
  final String title;
  final String note;
  final Timestamp? createdAt;
  final String priority; // 1 - Low, 2 - Medium, 3 - High
  final String category;
  final bool isCompleted;

  NoteModel({
    this.id,
    required this.title,
    required this.note,
    this.createdAt,
    this.priority='',
    this.category = "General",
    this.isCompleted = false,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      priority: json["priority"] ?? 1,
      category: json["category"] ?? "General",
      isCompleted: json["isCompleted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "note": note,
      "createdAt": createdAt,
      "priority": priority,
      "category": category,
      "isCompleted": isCompleted,
    };
  }

  NoteModel copyWith({String? id, String? title, String? note}) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note??this.note, createdAt: createdAt,
      category: category,
      isCompleted: isCompleted,
      priority: priority
    );
  }
}