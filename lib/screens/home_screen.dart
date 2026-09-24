import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../widgets/case_card.dart';
import 'new_case_screen.dart';
import 'case_detail_screen.dart';
import 'patterns_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> cases;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    cases = DBHelper.getAllCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social autopsy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PatternsScreen()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cases,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text('No cases yet. Log one.'));

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) => CaseCard(
              data: data[i],
              onTap: () async {
                final changed = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CaseDetailScreen(data: data[i])),
                );
                if (changed == true) setState(refresh);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCaseScreen()),
          );
          if (saved == true) setState(refresh);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
