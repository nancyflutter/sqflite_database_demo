const String tableNotes = "notes";

class KeepNoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, createdTime,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String description = 'description';
  static const String createdTime = 'createdTime';
}

class KeepNoteModel {
  final int? id;
  final String title;
  final bool isImportant;
  final int number;
  final String description;
  final DateTime createdTime;

  const KeepNoteModel({
    this.id,
    required this.title,
    required this.isImportant,
    required this.number,
    required this.description,
    required this.createdTime,
  });

  KeepNoteModel copy({
    int? id,
    String? title,
    bool? isImportant,
    int? number,
    String? description,
    DateTime? createdTime,
  }) =>
      KeepNoteModel(
        id: id ?? this.id,
        title: title ?? this.title,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static KeepNoteModel fromJson(Map<String, Object?> json) => KeepNoteModel(
        id: json[KeepNoteFields.id] as int?,
        isImportant: json[KeepNoteFields.isImportant] == 1,
        number: json[KeepNoteFields.number] as int,
        title: json[KeepNoteFields.title] as String,
        description: json[KeepNoteFields.description] as String,
        createdTime: DateTime.parse(json[KeepNoteFields.createdTime] as String),
      );

  Map<String, Object?> toJson() => {
        KeepNoteFields.id: id,
        KeepNoteFields.title: title,
        KeepNoteFields.isImportant: isImportant ? 1 : 0,
        KeepNoteFields.number: number,
        KeepNoteFields.description: description,
        KeepNoteFields.createdTime: createdTime.toIso8601String(),
      };
}
