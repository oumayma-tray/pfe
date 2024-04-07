class Email {
  final String sender;
  final String subject;
  final bool isStarred;
  final String senderImagePath;
  final String message;

  Email(
      {required this.sender,
      required this.subject,
      required this.isStarred,
      required this.senderImagePath,
      required this.message});
}
