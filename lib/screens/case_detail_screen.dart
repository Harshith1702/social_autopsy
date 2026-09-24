import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../widgets/severity_selector.dart';

class CaseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const CaseDetailScreen({super.key, required this.data});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  int recheckValue = 3;
  bool rechecking = false;

  Future<void> saveRecheck() async {
    await DBHelper.updateRecheck(widget.data['id'], recheckValue);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final closed = d['status'] == 'closed';

    return Scaffold(
      appBar: AppBar(title: Text('Case #${d['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(d['person'], style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(d['category'], style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            Text(d['description']),
            const SizedBox(height: 24),
            Text('Initial severity: ${d['severity_initial']}/5'),
            if (closed) ...[
              const SizedBox(height: 8),
              Text('Rechecked: ${d['severity_recheck']}/5'),
            ],
            const SizedBox(height: 32),
            if (!closed)
              rechecking
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Would you still call this a disaster'),
                        const SizedBox(height: 8),
                        SeveritySelector(
                          value: recheckValue,
                          onChanged: (v) => setState(() => recheckValue = v),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: saveRecheck, child: const Text('Confirm recheck')),
                      ],
                    )
                  : OutlinedButton(
                      onPressed: () => setState(() => rechecking = true),
                      child: const Text('Recheck this case'),
                    ),
          ],
        ),
      ),
    );
  }
}
