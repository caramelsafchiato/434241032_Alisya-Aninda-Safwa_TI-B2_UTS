class TicketEntity {
  final String id;
  final String title;
  final String description;
  final String status; 
  final String? imagePath; 
  final DateTime createdAt;

  TicketEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.imagePath,
    required this.createdAt,
  });
}