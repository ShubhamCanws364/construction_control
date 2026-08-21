class Communitie {
  final String name;
  final int totalInspections;
  final int scheduled;
  final int open;
  final int completed;

  final int totalIssues;
  final int created;
  final int fixed;
  final int pending;

  Communitie({
    required this.name,
    required this.totalInspections,
    required this.scheduled,
    required this.open,
    required this.completed,
    required this.totalIssues,
    required this.created,
    required this.fixed,
    required this.pending,
  });
}