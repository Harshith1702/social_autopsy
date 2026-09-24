import 'package:flutter/material.dart';

class CaseCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const CaseCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final open = data['status'] == 'open';
    return ListTile(
      onTap: onTap,
      title: Text('#${data['id']}  ${data['person']}'),
      subtitle: Text(data['category'], style: const TextStyle(color: Colors.white54)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${data['severity_initial']}/5'),
          Text(open ? 'OPEN' : 'CLOSED',
              style: TextStyle(fontSize: 11, color: open ? Colors.orangeAccent : Colors.white38)),
        ],
      ),
    );
  }
}
