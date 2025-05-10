class TaskModel {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? scheduledAt;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.scheduledAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        scheduledAt: DateTime.parse(json['scheduledAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'scheduledAt': scheduledAt?.toIso8601String(),
      };
}
