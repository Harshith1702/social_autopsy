import 'package:flutter/material.dart';
import '../constants.dart';
import '../db/db_helper.dart';
import '../widgets/severity_selector.dart';

class NewCaseScreen extends StatefulWidget {
  const NewCaseScreen({super.key});

  @override
  State<NewCaseScreen> createState() => _NewCaseScreenState();
}

class _NewCaseScreenState extends State<NewCaseScreen> {
  final personCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String category = categories.first;
  int severity = 3;

  Future<void> save() async {
    if (personCtrl.text.trim().isEmpty || descCtrl.text.trim().isEmpty) return;

    await DBHelper.insertCase({
      'person': personCtrl.text.trim(),
      'relationship': null,
      'date': DateTime.now().toIso8601String(),
      'description': descCtrl.text.trim(),
      'category': category,
      'severity_initial': severity,
      'status': 'open',
    });

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New case')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: personCtrl, decoration: const InputDecoration(labelText: 'Who')),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'What happened'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: category,
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => category = v!),
              decoration: const InputDecoration(labelText: 'Cause'),
            ),
            const SizedBox(height: 24),
            const Text('How bad'),
            const SizedBox(height: 8),
            SeveritySelector(value: severity, onChanged: (v) => setState(() => severity = v)),
            const SizedBox(height: 24),
            FilledButton(onPressed: save, child: const Text('Save case')),
          ],
        ),
      ),
    );
  }
}
