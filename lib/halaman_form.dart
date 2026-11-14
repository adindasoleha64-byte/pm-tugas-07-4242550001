import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanForm extends StatefulWidget {
  const HalamanForm({super.key});

  @override
  State<HalamanForm> createState() => _HalamanFormState();
}

class _HalamanFormState extends State<HalamanForm> {
  final _kunci = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late DateTime _tenggat;

  @override
  void initState() {
    super.initState();
    // Dibuat sekali di initState ...
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
    _tenggat = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    // ... dan wajib dibuang di dispose agar tidak bocor
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tenggat,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (!mounted) return; // halaman mungkin sudah ditutup selama await
    if (dipilih != null) setState(() => _tenggat = dipilih);
  }

  void _simpan() {
    if (!_kunci.currentState!.validate()) return;
    context.read<TugasModel>().tambah(
          judul: _judul.text.trim(),
          mataKuliah: _mataKuliah.text.trim(),
          tenggat: _tenggat,
        );
    context.pop(); // kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _kunci,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _judul,
                  decoration: const InputDecoration(
                    labelText: 'Judul tugas',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Judul wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mataKuliah,
                  decoration: const InputDecoration(
                    labelText: 'Mata kuliah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Mata kuliah wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: const Text('Tenggat'),
                  subtitle: Text(_tenggat.tanggal),
                  trailing: TextButton(
                    onPressed: _pilihTanggal,
                    child: const Text('Ubah'),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
