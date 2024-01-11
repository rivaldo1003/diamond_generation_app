import 'package:diamond_generation_app/features/comment/data/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Comment {
  final String text;

  Comment(this.text);
}

class CommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentProvider(),
      child: CommentScreen(),
    );
  }
}

class CommentScreen extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CommentProvider commentProvider = Provider.of<CommentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: commentProvider.comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(commentProvider.comments[index].text),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Comments'),
                        Divider(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: commentProvider.comments.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(commentProvider.comments[index].text),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _commentController,
                          decoration: InputDecoration(labelText: 'Add Comment'),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            commentProvider.addComment(_commentController.text);
                            _commentController.clear();
                            setState(() {}); // Update the bottom sheet content
                          },
                          child: Text('Add Comment'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
