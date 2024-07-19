import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/comment/data/comment_provider.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

class CommentWpda extends StatefulWidget {
  final WPDA wpda;
  final String deviceToken;

  CommentWpda({
    Key? key,
    required this.wpda,
    required this.deviceToken,
  }) : super(key: key);

  @override
  State<CommentWpda> createState() => _CommentWpdaState();
}

class _CommentWpdaState extends State<CommentWpda> {
  TextEditingController _commentController = TextEditingController();
  String? token;
  File? _image;
  final keyImageProfile = "image_profile";
  List<Comment> data = [];

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString(keyImageProfile);
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
        print(_image);
      });
    }
  }

  late LoginProvider loginProvider;
  String? _debugLabelString;

  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loadImage();
    getToken();

    // Directly sort comments during initialization
    data = List<Comment>.from(widget.wpda.comments)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> notificationOneSignal(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse(ApiConstants.notification);
      final response = await http.post(url, body: json.encode(body), headers: {
        'Authorization': 'Basic ${ApiConstants.ONE_SIGNAL_REST_API_KEY}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Status code : ${response.statusCode}');
        print('Success to send notif');
      } else {
        print('Failed to send notif. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
      throw Exception('Failed to send notif: $e');
    }
  }

  Future<void> addCommentWpda(
      Map<String, dynamic> body, String token, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.commentWpda),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CoolLoading(),
            );
          },
        );

        Future.delayed(Duration(seconds: 2), () async {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                'Komentar berhasil diunggah',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );

          // Access the full name of the commentator
          String? commenterFullName;
          for (var comment in widget.wpda.comments) {
            if (comment.comentator.id == comment.userId) {
              commenterFullName = comment.comentator.fullName;
              break; // Keluar dari loop setelah nilai ditemukan
            }
          }

          if (loginProvider.userId == null) {
            loginProvider.loadUserId();
            return CircularProgressIndicator();
          } else {
            // Pastikan commenterFullName tidak null sebelum mengirim notifikasi
            if (commenterFullName != null &&
                loginProvider.userId != widget.wpda.user_id) {
              // Mengirim notifikasi menggunakan OneSignal
              notificationOneSignal({
                "app_id": "ae235573-b52c-44a5-b2c3-23d9de4232fa",
                "wpda_owner_id": "${widget.wpda.id}",
                "commenter_name": commenterFullName,
                "include_player_ids": ["${widget.deviceToken}"],
                "contents": {
                  "en": "$commenterFullName mengomentari WPDA anda",
                }
              });
            }
          }
        });
      } else {
        throw Exception(
            'Failed to connect API comment WPDA. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in commentWpda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColor.colorRed,
          content: Text(
            'Gagal mengirim komentar. Periksa koneksi internet Anda.',
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.whiteColor,
            ),
          ),
        ),
      );
    }
  }

  Future<void> deleteComment(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.deleteCommentWpda}/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Delete successfully');

        // Perbarui tampilan
        if (mounted) {
          setState(() {});
        }
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      print('Error in deleteComment: $e');
      // Handle error, tampilkan pesan atau notifikasi jika diperlukan
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            barWidget(),
            Expanded(
              child: (data.isEmpty)
                  ? Center(
                      child: Text(
                        'Belum ada komentar',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final Duration timeDifference = DateTime.now()
                            .difference(DateTime.parse(data[index].createdAt));
                        final resultTime = timeago.format(
                            DateTime.now().subtract(timeDifference),
                            locale: 'id');

                        int loginId =
                            int.parse(loginProvider.userId.toString());
                        int commentId =
                            int.parse(data[index].comentator.id.toString());

                        return ListTile(
                          onLongPress: () async {
                            (loginId == commentId)
                                ? await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Konfirmasi hapus komentar',
                                          style: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.bold,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        content: Text(
                                          'Apakah anda yakin ingin menghapus komentar ini?',
                                          style: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.w500,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text(
                                              'Batal',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.bold,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                String commentId =
                                                    data[index].id.toString();
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return Center(
                                                      child: CoolLoading(),
                                                    );
                                                  },
                                                );
                                                Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                                    Navigator.of(context).pop();
                                                    await deleteComment(
                                                      commentId,
                                                      token!,
                                                    );
                                                    setState(() {
                                                      data.removeAt(index);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              MyColor
                                                                  .colorGreen,
                                                          content: Text(
                                                            'Komentar berhasil dihapus',
                                                            style: MyFonts
                                                                .customTextStyle(
                                                              14,
                                                              FontWeight.w500,
                                                              MyColor
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        MyColor.colorRed,
                                                    content: Text(
                                                      'Gagal menghapus komentar',
                                                      style: MyFonts
                                                          .customTextStyle(
                                                        14,
                                                        FontWeight.w500,
                                                        MyColor.whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Hapus',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.bold,
                                                MyColor.colorRed,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : SizedBox();
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: (data[index]
                                      .comentator
                                      .profilePicture
                                      .isEmpty)
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/profile_empty.jpg',
                                      ),
                                    )
                                  : Image.network(
                                      'https://gsjasungaikehidupan.com/storage/profile_pictures/${data[index].comentator.profilePicture}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data[index].comentator.fullName,
                                  style: MyFonts.customTextStyle(
                                    10,
                                    FontWeight.bold,
                                    MyColor.whiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                resultTime,
                                style: MyFonts.customTextStyle(
                                  10,
                                  FontWeight.w400,
                                  MyColor.greyText,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            data[index].commentsContent,
                            style: MyFonts.customTextStyle(
                              12,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Consumer<LoginProvider>(
              builder: (context, value, _) {
                if (value.fullName == null) {
                  value.loadFullName();
                  return CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        (_image == null)
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/profile_empty.jpg',
                                ),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: FileImage(_image!),
                              ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFieldWidget(
                            fillColor: Colors.transparent,
                            borderSide: BorderSide(
                              color: MyColor.greyText.withOpacity(0.1),
                              width: 0.9,
                            ),
                            textStyle: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                            hintText: 'Tambahkan komentar',
                            obscureText: false,
                            controller: _commentController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                OneSignal.Notifications.addClickListener(
                                    (event) {
                                  print(
                                      'NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
                                  _debugLabelString =
                                      "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
                                });
                                print('Device Token : ${widget.deviceToken}');
                                if (_commentController.text.isNotEmpty) {
                                  final commentWpda = Comment(
                                    id: 1,
                                    wpdaId: 1,
                                    userId: 1,
                                    commentsContent: _commentController.text,
                                    createdAt: DateTime.now().toString(),
                                    comentator: Comentator(
                                      id: 1,
                                      fullName: value.fullName!,
                                      email: '',
                                      profilePicture:
                                          'profile_pictures/user_${value.userId}.jpg',
                                    ),
                                  );

                                  // Tambahkan komentar langsung ke WPDA dan perbarui tampilan
                                  widget.wpda.comments.add(commentWpda);
                                  addCommentWpda(
                                    {
                                      'wpda_id': widget.wpda.id,
                                      'comments_content':
                                          _commentController.text,
                                      'created_at': DateTime.now().toString(),
                                    },
                                    token!,
                                    context,
                                  );
                                  setState(() {
                                    _commentController.clear();
                                    // Sort comments after adding a new one
                                    data = List<Comment>.from(
                                        widget.wpda.comments)
                                      ..sort((a, b) =>
                                          b.createdAt.compareTo(a.createdAt));
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget barWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 4,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Komentar ${data.length}',
          style: MyFonts.customTextStyle(
            12,
            FontWeight.bold,
            MyColor.whiteColor,
          ),
        ),
      ],
    );
  }
}

class PartialCommentWpda extends StatelessWidget {
  final WPDA wpda;
  final String deviceToken;

  PartialCommentWpda({
    Key? key,
    required this.wpda,
    required this.deviceToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adjust the height according to your requirement
    double partialScreenHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: partialScreenHeight,
      child: CommentWpda(
        wpda: wpda,
        deviceToken: deviceToken,
      ),
    );
  }
}
