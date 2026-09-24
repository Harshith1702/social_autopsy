import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../db/case_queries.dart';

class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patterns')),
      body: FutureBuilder(
        future: Future.wait([categoryBreakdown(), severityDecay(), repeatOffenders()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final breakdown = snapshot.data![0] as Map<String, int>;
          final decay = snapshot.data![1] as ({double initial, double recheck});
          final offenders = snapshot.data![2] as List<Map<String, dynamic>>;

          if (breakdown.isEmpty) {
            return const Center(child: Text('No cases logged yet'));
          }

          final total = breakdown.values.fold(0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('$total cases logged', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(PieChartData(
                  sections: breakdown.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      title: '${e.value}',
                      radius: 60,
                    );
                  }).toList(),
                )),
              ),
              const SizedBox(height: 8),
              ...breakdown.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(e.key), Text('${e.value}')],
                    ),
                  )),
              const SizedBox(height: 32),
              if (decay.initial > 0) ...[
                const Text('Severity decay', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('At the time: ${decay.initial.toStringAsFixed(1)} / 5'),
                Text('After a recheck: ${decay.recheck.toStringAsFixed(1)} / 5'),
                const SizedBox(height: 32),
              ],
              if (offenders.isNotEmpty) ...[
                const Text('Repeat offenders', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...offenders.map((o) => Text('${o['person']}: ${o['category']} x${o['count']}')),
              ],
            ],
          );
        },
      ),
    );
  }
}
