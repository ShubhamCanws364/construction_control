class Inspection {
  final String id;
  final String title;
  final String inspector;
  final String lot;
  final String status;
  final String date;
  final String time;
  final int totalIssues;
  final int closedIssues;
  final int openIssues;

  Inspection({
    required this.id,
    required this.title,
    required this.inspector,
    required this.lot,
    required this.status,
    required this.date,
    required this.time,
    required this.totalIssues,
    required this.closedIssues,
    required this.openIssues,
  });
}