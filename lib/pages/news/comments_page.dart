// File: lib/pages/news/comments_page.dart
// HALAMAN FULL COMMENTS dengan list semua comments dan input box

import 'package:flutter/material.dart';
import '../../models/comment_model.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;
  final int commentCount;

  const CommentsPage({
    Key? key,
    required this.comments,
    required this.commentCount,
  }) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
  }

  void _sendComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(
          Comment(
            id: _comments.length + 1,
            author: "You",
            time: "Just now",
            text: _commentController.text,
            likes: 0,
            replies: [],
          ),
        );
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCommentsHeader(),
          _buildCommentsList(),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_comments.length} Comments',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                'All Comments',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildCommentWithReplies(_comments[index]),
          );
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600], size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Type message',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendComment(),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: _sendComment,
              icon: const Icon(Icons.send, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentWithReplies(Comment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentItem(comment, false),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 12),
            child: Column(
              children: comment.replies
                  .map((reply) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCommentItem(reply, true),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment, bool isReply) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isReply ? 16 : 20,
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.person,
            color: Colors.grey[600],
            size: isReply ? 18 : 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                comment.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${comment.likes}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Reply',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}