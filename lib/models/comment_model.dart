class Comment {
  final int id;
  final String author;
  final String time;
  final String text;
  final int likes;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.author,
    required this.time,
    required this.text,
    required this.likes,
    required this.replies,
  });
}