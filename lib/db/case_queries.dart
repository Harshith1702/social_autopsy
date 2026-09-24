import 'package:collection/collection.dart';
import 'db_helper.dart';

Future<Map<String, int>> categoryBreakdown() async {
  final rows = await DBHelper.getAllCases();
  final counts = <String, int>{};
  for (final r in rows) {
    final cat = r['category'] as String;
    counts[cat] = (counts[cat] ?? 0) + 1;
  }
  return counts;
}

Future<({double initial, double recheck})> severityDecay() async {
  final rows = await DBHelper.getAllCases();
  final rechecked = rows.where((r) => r['severity_recheck'] != null);
  if (rechecked.isEmpty) return (initial: 0, recheck: 0);

  final initAvg = rechecked.map((r) => r['severity_initial'] as int).average;
  final rechkAvg = rechecked.map((r) => r['severity_recheck'] as int).average;
  return (initial: initAvg, recheck: rechkAvg);
}

Future<List<Map<String, dynamic>>> repeatOffenders() async {
  final rows = await DBHelper.getAllCases();
  final grouped = <String, List<Map<String, dynamic>>>{};

  for (final r in rows) {
    grouped.putIfAbsent('${r['person']}_${r['category']}', () => []).add(r);
  }

  return grouped.values
      .where((g) => g.length >= 2)
      .map((g) => {
            'person': g.first['person'],
            'category': g.first['category'],
            'count': g.length,
          })
      .toList();
}
