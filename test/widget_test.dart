import 'package:flutter_test/flutter_test.dart';
import 'package:planner_tugas/main.dart';
import 'package:planner_tugas/tugas_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Aplikasi menampilkan halaman daftar tugas', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TugasModel(),
        child: const TugasApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Planner Tugas'), findsOneWidget);
    expect(find.text('Tidak ada tugas'), findsOneWidget);
  });
}
