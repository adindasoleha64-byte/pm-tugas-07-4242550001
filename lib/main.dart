import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'halaman_daftar.dart';
import 'halaman_form.dart';
import 'halaman_statistik.dart';
import 'tugas_model.dart';

/// Data contoh agar aplikasi tidak kosong saat pertama dibuka.
List<TugasKuliah> _dataAwal() {
  final sekarang = DateTime.now();
  return [
    TugasKuliah(
      id: 1,
      judul: 'Laporan praktikum Flutter',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: sekarang.add(const Duration(days: 3)),
    ),
    TugasKuliah(
      id: 2,
      judul: 'Resume bab 4',
      mataKuliah: 'Basis Data',
      tenggat: sekarang.add(const Duration(days: 7)),
    ),
  ];
}

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => TugasModel(awal: _dataAwal()), // satu objek untuk app
    child: const TugasApp(),
  ),
);

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanDaftar(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistik',
              builder: (context, state) => const HalamanStatistik(),
            ),
          ],
        ),
      ],
    ),
    // Di luar shell: form tampil penuh tanpa navigasi, dibuka dengan push
    GoRoute(path: '/tambah', builder: (context, state) => const HalamanForm()),
  ],
);

class TugasApp extends StatelessWidget {
  const TugasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Planner Tugas Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3949AB)),
      ),
      routerConfig: _router,
    );
  }
}

/// < 840 dp: NavigationBar di bawah; >= 840 dp: NavigationRail di samping.
class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _pilih(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    // select: hanya dibangun ulang bila jumlah tugas aktif berubah
    final aktif = context.select((TugasModel m) => m.jumlahAktif);
    final ikonTugas = Badge.count(
      count: aktif,
      isLabelVisible: aktif > 0,
      child: const Icon(Icons.checklist),
    );
    final lebar = MediaQuery.sizeOf(context).width;

    if (lebar >= 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _pilih,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: ikonTugas,
                  label: const Text('Tugas'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text('Statistik'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _pilih,
        destinations: [
          NavigationDestination(icon: ikonTugas, label: 'Tugas'),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
