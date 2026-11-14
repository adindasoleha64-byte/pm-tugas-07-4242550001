import 'package:flutter_test/flutter_test.dart';
import 'package:planner_tugas/tugas_model.dart';

void main() {
  final tenggat = DateTime(2026, 12, 1);

  test('tambah menambah tugas dan memberi notifikasi', () {
    final m = TugasModel();
    var notifikasi = 0;
    m.addListener(() => notifikasi++);

    m.tambah(judul: 'Laporan', mataKuliah: 'PM', tenggat: tenggat);
    m.tambah(judul: 'Resume', mataKuliah: 'BD', tenggat: tenggat);

    expect(m.total, 2);
    expect(m.jumlahAktif, 2);
    expect(notifikasi, 2);
  });

  test('tandaiSelesai memperbarui jumlah dan persentase', () {
    final m = TugasModel();
    m.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    m.tambah(judul: 'B', mataKuliah: 'Y', tenggat: tenggat);
    final id = m.daftar.first.id;

    m.tandaiSelesai(id);
    expect(m.jumlahSelesai, 1);
    expect(m.jumlahAktif, 1);
    expect(m.persentaseSelesai, 50);

    m.tandaiSelesai(id, selesai: false);
    expect(m.jumlahSelesai, 0);
  });

  test('hapus membuang tugas; ID tidak dikenal tidak memberi notifikasi', () {
    final m = TugasModel();
    m.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    final id = m.daftar.single.id;

    var notifikasi = 0;
    m.addListener(() => notifikasi++);

    m.hapus(999);
    expect(notifikasi, 0);

    m.hapus(id);
    expect(m.total, 0);
    expect(notifikasi, 1);
  });

  test('persentase 0 saat daftar kosong (tanpa pembagian nol)', () {
    expect(TugasModel().persentaseSelesai, 0);
  });
}
