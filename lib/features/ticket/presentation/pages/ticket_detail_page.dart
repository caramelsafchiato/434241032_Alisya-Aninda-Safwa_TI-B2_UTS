import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_provider.dart';

class TicketDetailPage extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final currentTicket = appProvider.tickets.firstWhere(
      (t) => t['id'] == widget.ticket['id'],
      orElse: () => widget.ticket,
    );
    final comments = (currentTicket['comments'] as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Detail ${currentTicket['id']}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Status: ${currentTicket['status']}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentTicket['title'] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Pelapor: ${currentTicket['reporter']}"),
            const SizedBox(height: 10),
            const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(currentTicket['description'] as String),
            const SizedBox(height: 20),

            const Text("Lampiran:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: currentTicket['imagePath'] == null
                  ? const Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'File tersimpan: ${currentTicket['imagePath']}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),

            if (appProvider.canManageTicket) ...[
              const SizedBox(height: 20),
              const Text('Update Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildStatusChip(context, appProvider, currentTicket['id'] as String, 'Open'),
                  _buildStatusChip(context, appProvider, currentTicket['id'] as String, 'In Progress'),
                  _buildStatusChip(context, appProvider, currentTicket['id'] as String, 'Resolved'),
                ],
              ),
            ],

            const Divider(height: 40),
            const Text("Komentar / Balasan:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (comments.isEmpty)
              const Text('Belum ada komentar')
            else
              ...comments.map(
                (comment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(comment['author'] ?? '-'),
                  subtitle: Text(comment['text'] ?? '-'),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: "Tulis balasan...",
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                appProvider.addComment(currentTicket['id'] as String, _commentController.text);
                _commentController.clear();
              },
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    AppProvider appProvider,
    String ticketId,
    String targetStatus,
  ) {
    return ActionChip(
      label: Text(targetStatus),
      onPressed: () {
        appProvider.updateTicketStatus(ticketId, targetStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status tiket menjadi $targetStatus')),
        );
      },
    );
  }
}