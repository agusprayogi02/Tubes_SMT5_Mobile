import 'package:equatable/equatable.dart';

class PenilaianModel extends Equatable {
  final String alternatifId;
  final String kriteriaId;
  final num nilai;
  final DateTime createdAt;

  const PenilaianModel({
    this.kriteriaId = '',
    this.alternatifId = '',
    this.nilai = 0,
    required this.createdAt,
  });

  factory PenilaianModel.fromJson(Map<String, Object?> json) {
    return PenilaianModel(
      kriteriaId: json['kriteria_id'] as String? ?? '',
      alternatifId: json['alternatif_id'] as String? ?? '',
      nilai: (json['nilai'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['created_at'] as String),
    );
  }
  factory PenilaianModel.initial(
      String alternatifId, String kriteriaId, double nilai) {
    return PenilaianModel(
      alternatifId: alternatifId,
      kriteriaId: kriteriaId,
      nilai: nilai,
      createdAt: DateTime.now(),
    );
  }

  Map<String, Object?> toJson() => {
        'alternatif_id': alternatifId,
        'kriteria_id': kriteriaId,
        'nilai': nilai,
        'created_at': createdAt.toIso8601String(),
      };

  PenilaianModel copyWith({
    String? alternatifId,
    String? kriteriaId,
    double? nilai,
    DateTime? createdAt,
  }) {
    return PenilaianModel(
      alternatifId: alternatifId ?? this.alternatifId,
      kriteriaId: kriteriaId ?? this.kriteriaId,
      nilai: nilai ?? this.nilai,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [alternatifId, kriteriaId, nilai, createdAt];
}
