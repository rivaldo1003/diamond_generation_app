import 'dart:convert';
import 'dart:io';

import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/widgets/placeholder_all_user.dart';

class CommentScreen extends StatefulWidget {
  final WPDA wpda;

  const CommentScreen({
    Key? key,
    required this.wpda,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>
    with WidgetsBindingObserver {
  String? imgUrl;
  String? imgData;
  late TextEditingController commentController;
  late GetWpdaUsecase getWpdaUsecase;
  late String? fullName;
  late String? token;
  late bool isLoading;
  late double containerHeight;
  late File? _image;
  late final keyImageProfile = "image_profile";

  String buildImageUrlWithStaticTimestamp(String? profilePicture) {
    if (profilePicture != null &&
        profilePicture.isNotEmpty &&
        profilePicture != 'null') {
      // Tambahkan timestamp sebagai parameter query string
      return Uri.https(
              'gsjasungaikehidupan.com',
              '/storage/profile_pictures/$profilePicture',
              {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()})
          .toString();
    } else {
      return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
    }
  }

  @override
  void initState() {
    super.initState();
    commentsWpda = widget.wpda.comments.map((comment) {
      imgData =
          buildImageUrlWithStaticTimestamp(comment.comentator.profilePicture);
      print('IMG DATA : ${imgData}');
      return Comment(
          commentsContent: comment.commentsContent,
          commentator: comment.comentator.fullName,
          fullName: comment.comentator.fullName,
          createdAt: comment.createdAt,
          profilePicture: comment.comentator.profilePicture);
    }).toList();
    commentController = TextEditingController();
    isLoading = true;
    containerHeight = 600;
    _image = null;
    getFullName();
    loadImage();
    getWpdaUsecase = Provider.of<GetWpdaUsecase>(context, listen: false);
    getToken().then((value) {
      Future.delayed(
        Duration(
          seconds: 2,
        ),
        () {
          if (mounted) {
            setState(() {
              isLoading = false;
              getWpdaUsecase.getAllWpda(token!);
            });
          }
        },
      );
    });

    WidgetsBinding.instance.addObserver(this);

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        print(visible);
        setContainerHeight();
      } else {
        resetContainerHeight();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (MediaQuery.of(context).viewInsets.bottom == 0.0) {
      resetContainerHeight();
    }
  }

  void setContainerHeight() {
    if (mounted) {
      setState(() {
        containerHeight = MediaQuery.of(context).size.height / 1.1;
      });
    }
  }

  void resetContainerHeight() {
    if (mounted) {
      setState(() {
        containerHeight = 600;
      });
    }
  }

  Future<void> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString(SharedPreferencesManager.keyFullName);
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

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  Future<void> commentWpda(
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

        // Perbarui data komentar langsung setelah menambahkan komentar
        await getWpdaUsecase.getAllWpda(token);

        Future.delayed(Duration(seconds: 2), () {
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

  @override
  Widget build(BuildContext context) {
    print('Comment total : ${widget.wpda.comments.length}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 8),
          barWidget(),
          SizedBox(height: 8),
          (isLoading)
              ? Expanded(
                  child: Center(
                    child: PlaceholderAllUser(),
                  ),
                )
              : (widget.wpda.comments.isEmpty)
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'Belum ada komentar',
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.w500,
                            MyColor.whiteColor,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: CommentList(
                        wpda: widget.wpda,
                        commentsWpda: commentsWpda,
                      ),
                    ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: MyColor.greyText.withOpacity(0.1),
                ),
              ),
            ),
            child: _buildCommentInput(),
          ),
        ],
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
          'Komentar ${commentsWpda.length}',
          style: MyFonts.customTextStyle(
            14,
            FontWeight.bold,
            MyColor.whiteColor,
          ),
        ),
      ],
    );
  }

  Future<void> _addComment() async {
    String newComment = commentController.text;

    // Simpan komentar ke server atau state sesuai kebutuhan aplikasi
    await commentWpda({
      'wpda_id': widget.wpda.id,
      'comments_content': commentController.text,
    }, token!, context);

    String extractPathFromUrl(String url) {
      Uri uri = Uri.parse(url);

      // Ambil path dari URI
      String path = uri.path;

      // Tambahkan query string jika ada
      if (uri.hasQuery) {
        path += '?' + uri.query;
      }

      return path;
    }

    String path = extractPathFromUrl(imgData!);

    // Setelah sukses, tambahkan komentar ke daftar dan perbarui data
    Comment newCommentObject = Comment(
      commentsContent: newComment,
      commentator: '', // Gantilah dengan nama pengguna yang sesuai
      fullName: fullName!, // Gantilah dengan nama pengguna yang sesuai
      createdAt: DateTime.now().toIso8601String(),
      profilePicture: '$path',
    );

    commentsWpda.add(newCommentObject);
    commentController.clear();

    // Perbarui tampilan
    if (mounted) {
      setState(() {});
    }
  }

  List<Comment> commentsWpda = [];

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16),
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
          SizedBox(width: 16),
          Expanded(
            child: TextFieldWidget(
              hintText: 'Tambahkan komentar',
              controller: commentController,
              obscureText: false,
              fillColor: Colors.transparent,
              borderSide: BorderSide(
                color: MyColor.greyText.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            onPressed: () {
              _addComment();
            },
            icon: Icon(
              Icons.send,
              color: MyColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final WPDA wpda;
  List<Comment> commentsWpda;

  CommentList({
    Key? key,
    required this.wpda,
    required this.commentsWpda,
  }) : super(key: key);

  String? imgUrl;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return ListView.builder(
        itemCount: commentsWpda.length,
        itemBuilder: (context, index) {
          final Duration timeDifference = DateTime.now()
              .difference(DateTime.parse(commentsWpda[index].createdAt));
          final resultTime =
              timeago.format(DateTime.now().subtract(timeDifference));
          String buildImageUrlWithStaticTimestamp(String? profilePicture) {
            if (profilePicture != null &&
                profilePicture.isNotEmpty &&
                profilePicture != 'null') {
              // Tambahkan timestamp sebagai parameter query string
              return Uri.https('gsjasungaikehidupan.com',
                  '/storage/profile_pictures/$profilePicture', {
                'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
              }).toString();
            } else {
              return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
            }
          }

          imgUrl = commentsWpda[index].profilePicture;
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    commentsWpda[index].fullName,
                    style: MyFonts.customTextStyle(
                      10,
                      FontWeight.w500,
                      MyColor.whiteColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  resultTime,
                  style: MyFonts.customTextStyle(
                    10,
                    FontWeight.w500,
                    MyColor.greyText,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              commentsWpda[index].commentsContent,
              style: MyFonts.customTextStyle(
                12,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
            leading: (imgUrl!.isEmpty || imgUrl == null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imgUrl!),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'https://gsjasungaikehidupan.com/storage/profile_pictures/${commentsWpda[index].profilePicture}'),
                  ),
          );
        },
      );
    });
  }
}

class PartialCommentScreen extends StatelessWidget {
  final WPDA wpda;

  PartialCommentScreen({
    Key? key,
    required this.wpda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adjust the height according to your requirement
    double partialScreenHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: partialScreenHeight,
      child: CommentScreen(wpda: wpda),
    );
  }
}

class Comment {
  final String commentsContent;
  final String commentator;
  final String fullName; // tambahkan field fullName
  final String createdAt; // tambahkan field createdAt
  final String profilePicture; // tambahkan field createdAt

  Comment({
    required this.commentsContent,
    required this.commentator,
    required this.fullName,
    required this.createdAt,
    required this.profilePicture,
  });
}
