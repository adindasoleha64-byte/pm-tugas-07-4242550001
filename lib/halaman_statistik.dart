import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: halaman ini otomatis ikut berubah saat tugas diubah di halaman lain
    final m = context.watch<TugasModel>();
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tugas selesai', style: teks.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${m.persentaseSelesai.toStringAsFixed(0)}%',
                        style: teks.displaySmall,
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: m.total == 0 ? 0 : m.jumlahSelesai / m.total,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _KartuAngka(label: 'Total', nilai: m.total),
                  const SizedBox(width: 12),
                  _KartuAngka(label: 'Selesai', nilai: m.jumlahSelesai),
                  const SizedBox(width: 12),
                  _KartuAngka(label: 'Aktif', nilai: m.jumlahAktif),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KartuAngka extends StatelessWidget {
  const _KartuAngka({required this.label, required this.nilai});

  final String label;
  final int nilai;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Text('$nilai', style: teks.headlineMedium),
              const SizedBox(height: 4),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
