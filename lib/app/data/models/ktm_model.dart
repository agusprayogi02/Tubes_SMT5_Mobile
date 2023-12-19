import 'package:equatable/equatable.dart';

class KtmModel extends Equatable {
  final String dusun;
  final String foto;
  final String jalan;
  final String kota;
  final String lahir;
  final String nama;
  final String nim;
  final String prodi;

  /// penilaian sudah terisi
  final bool filled;

  /// nilai hasil penilaian
  final num nilai;
  final DateTime? createdAt;

  const KtmModel({
    this.dusun = '',
    this.foto = '',
    this.jalan = '',
    this.kota = '',
    this.lahir = '',
    this.nama = '',
    this.nim = '',
    this.prodi = '',
    this.filled = false,
    this.nilai = 0,
    this.createdAt,
  });

  factory KtmModel.fromJson(Map<Object?, Object?> json) => KtmModel(
        dusun: json['dusun'] as String? ?? '',
        foto: json['foto'] as String? ?? '',
        jalan: json['jalan'] as String? ?? '',
        kota: json['kota'] as String? ?? '',
        lahir: json['lahir'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
        nim: json['nim'] as String? ?? '',
        prodi: json['prodi'] as String? ?? '',
        filled: json['filled'] as bool? ?? false,
        nilai: json['nilai'] as num? ?? 0,
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      );

  factory KtmModel.initial(Map<String, Object?> json) => KtmModel(
        dusun: json['dusun'] as String? ?? '',
        foto: json['foto'] as String? ?? '',
        jalan: json['jalan'] as String? ?? '',
        kota: json['kota'] as String? ?? '',
        lahir: json['lahir'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
        nim: json['nim'] as String? ?? '',
        prodi: json['prodi'] as String? ?? '',
        filled: false,
        nilai: 0,
        createdAt: DateTime.now(),
      );

  Map<String, Object?> toJson() => {
        'dusun': dusun,
        'foto': foto,
        'jalan': jalan,
        'kota': kota,
        'lahir': lahir,
        'nama': nama,
        'nim': nim,
        'prodi': prodi,
        'filled': filled,
        'nilai': nilai,
        'created_at': createdAt?.toIso8601String(),
      };

  KtmModel copyWith({
    String? dusun,
    String? foto,
    String? jalan,
    String? kota,
    String? lahir,
    String? nama,
    String? nim,
    String? prodi,
    bool? filled,
    num? nilai,
    DateTime? createdAt,
  }) {
    return KtmModel(
      dusun: dusun ?? this.dusun,
      foto: foto ?? this.foto,
      jalan: jalan ?? this.jalan,
      kota: kota ?? this.kota,
      lahir: lahir ?? this.lahir,
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      filled: filled ?? this.filled,
      nilai: nilai ?? this.nilai,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props {
    return [
      dusun,
      foto,
      jalan,
      kota,
      lahir,
      nama,
      nim,
      prodi,
      filled,
      nilai,
      createdAt,
    ];
  }
}
