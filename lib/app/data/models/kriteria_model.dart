import 'package:equatable/equatable.dart';

class KriteriaModel extends Equatable {
  final String name;
  final num w;
  final bool isBenefit;
  final DateTime createdAt;

  const KriteriaModel({
    this.name = '',
    this.w = 0,
    this.isBenefit = true,
    required this.createdAt,
  });

  KriteriaModel copyWith({
    String? name,
    num? w,
    bool? isBenefit,
    DateTime? createdAt,
  }) {
    return KriteriaModel(
      name: name ?? this.name,
      w: w ?? this.w,
      isBenefit: isBenefit ?? this.isBenefit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'w': w,
      'is_benefit': isBenefit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory KriteriaModel.fromMap(Map<dynamic, dynamic> map) {
    return KriteriaModel(
      name: map['name'] ?? '',
      w: map['w'] ?? 0,
      isBenefit: map['is_benefit'] ?? false,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at'] as String),
    );
  }

  factory KriteriaModel.init() {
    return KriteriaModel(
      name: '',
      w: 0,
      isBenefit: true,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object> get props => [name, w, isBenefit, createdAt];
}
