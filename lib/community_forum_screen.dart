import 'package:flutter/material.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'user': 'Sarah Johnson',
      'avatar': 'S',
      'time': '2 hours ago',
      'title': 'Found this beautiful quartz crystal!',
      'content': 'Discovered during a hike in the Rocky Mountains. Can anyone help identify the exact type?',
      'likes': 24,
      'comments': 8,
    },
    {
      'user': 'Mike Chen',
      'avatar': 'M',
      'time': '5 hours ago',
      'title': 'Best locations for fossil hunting?',
      'content': 'Planning a trip next month. Looking for recommendations on fossil-rich areas.',
      'likes': 15,
      'comments': 12,
    },
  ];

  void _addPost() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _posts.insert(0, {
                    'user': 'You',
                    'avatar': 'Y',
                    'time': 'Just now',
                    'title': titleController.text,
                    'content': contentController.text,
                    'likes': 0,
                    'comments': 0,
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text('Community Forum'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(post['avatar'], style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post['user'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(post['time'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(post['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(post['content'], style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up_outlined, size: 20),
                        onPressed: () => setState(() => post['likes']++),
                        color: Colors.indigo,
                      ),
                      Text('${post['likes']}', style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(width: 16),
                      Icon(Icons.comment_outlined, size: 20, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${post['comments']}', style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
