import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

enum FilterTugas {
  semua('Semua'),
  aktif('Aktif'),
  selesai('Selesai');

  const FilterTugas(this.label);
  final String label;
}

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  // Ephemeral state: filter hanya dipakai halaman ini -> setState
  FilterTugas _filter = FilterTugas.semua;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>(); // app state: ikut berubah
    final skema = Theme.of(context).colorScheme;

    final tampil = switch (_filter) {
      FilterTugas.semua => model.daftar,
      FilterTugas.aktif => model.daftar.where((t) => !t.selesai).toList(),
      FilterTugas.selesai => model.daftar.where((t) => t.selesai).toList(),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Planner Tugas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final f in FilterTugas.values)
                    FilterChip(
                      label: Text(f.label),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? const Center(child: Text('Tidak ada tugas'))
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: tampil.length,
                    separatorBuilder: (context, i) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final t = tampil[i];
                      final terlambat =
                          !t.selesai && t.tenggat.isBefore(DateTime.now());
                      return ListTile(
                        leading: Checkbox(
                          value: t.selesai,
                          // read di dalam callback: tidak perlu mendengarkan
                          onChanged: (v) => context
                              .read<TugasModel>()
                              .tandaiSelesai(t.id, selesai: v ?? false),
                        ),
                        title: Text(
                          t.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration:
                                t.selesai ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          '${t.mataKuliah} • ${t.tenggat.tanggal}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: terlambat ? TextStyle(color: skema.error) : null,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Hapus',
                          onPressed: () =>
                              context.read<TugasModel>().hapus(t.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
