import 'package:flutter/foundation.dart';

/// Model satu tugas kuliah (immutable).
class TugasKuliah {
  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  final bool selesai;

  TugasKuliah copyWith({bool? selesai}) => TugasKuliah(
        id: id,
        judul: judul,
        mataKuliah: mataKuliah,
        tenggat: tenggat,
        selesai: selesai ?? this.selesai,
      );
}

/// State bersama (app state): dipakai halaman daftar, form, statistik,
/// dan badge navigasi. Tidak mengimpor pustaka UI, jadi mudah diuji.
class TugasModel extends ChangeNotifier {
  TugasModel({List<TugasKuliah> awal = const []})
      : _daftar = List.of(awal),
        _idBerikut = awal.fold(0, (m, t) => t.id > m ? t.id : m) + 1;

  final List<TugasKuliah> _daftar;
  int _idBerikut;

  List<TugasKuliah> get daftar => List.unmodifiable(_daftar);
  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;
  double get persentaseSelesai =>
      total == 0 ? 0 : jumlahSelesai / total * 100;

  void tambah({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    _daftar.add(TugasKuliah(
      id: _idBerikut++,
      judul: judul,
      mataKuliah: mataKuliah,
      tenggat: tenggat,
    ));
    notifyListeners();
  }

  void tandaiSelesai(int id, {bool selesai = true}) {
    final i = _daftar.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _daftar[i] = _daftar[i].copyWith(selesai: selesai);
    notifyListeners();
  }

  void hapus(int id) {
    final sebelum = _daftar.length;
    _daftar.removeWhere((t) => t.id == id);
    if (_daftar.length != sebelum) notifyListeners();
  }
}

extension FormatTanggal on DateTime {
  /// 5 Nov 2026 -> 05/11/2026
  String get tanggal =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
}
