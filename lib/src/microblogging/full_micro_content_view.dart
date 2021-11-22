import 'package:flutter/material.dart';
import 'package:metapersona/src/microblogging/micro_content_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/microblogging/microblog_view.dart';
import 'package:metapersona/src/utils.dart';

class FullMicroContentView extends StatelessWidget {
  const FullMicroContentView({Key? key, required this.micro}) : super(key: key);
  final MicroBlogItem micro;

  @override
  Widget build(BuildContext context) {
    return MicroContentView(
      micro: micro,
      imageFolder: getRootUrlPrefix() +
          MicroBlogView.microsPath +
          MicroBlog.storageFolderPath,
      onNavigateToMicro: () {},
    );
  }
}
