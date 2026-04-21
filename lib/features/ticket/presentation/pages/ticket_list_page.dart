import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_provider.dart';
import 'ticket_detail_page.dart';

class TicketListPage extends StatelessWidget {
  const TicketListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final tickets = appProvider.visibleTickets;

    return Scaffold(
      appBar: AppBar(title: Text(appProvider.role == 'User' ? 'Tiket Saya' : 'Daftar Tiket')),
      body: tickets.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
              itemCount: tickets.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final createdAt = ticket['createdAt'] as DateTime;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(ticket['id'].toString().replaceAll('TKT-', '')),
                    ),
                    title: Text(ticket['title'] as String),
                    subtitle: Text(
                      "${ticket['id']} • ${createdAt.day}/${createdAt.month}/${createdAt.year} • Pelapor: ${ticket['reporter']}",
                    ),
                    trailing: Text(
                      ticket['status'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketDetailPage(ticket: ticket)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}