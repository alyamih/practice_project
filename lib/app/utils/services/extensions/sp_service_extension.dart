import 'dart:convert';

import 'package:practice_project/app/utils/services/sp_service.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

extension PostsSp on SpService {
  List<PostModel> getPostsData(String key) {
    return getListData(key)
            ?.map(
              (e) => PostModel.fromJson(jsonDecode(e) as Map<String, dynamic>),
            )
            .toList() ??
        [];
  }

  Future<void> setPostsData(String key, List<PostModel> value) async {
    await setListData(
        key,
        value
            .map(
              (e) => jsonEncode(e),
            )
            .toList());
  }

  addPostData(String key, PostModel value) async {
    var posts = getPostsData(key);
    posts.add(value);
    await setPostsData(key, posts);
  }

  removePostsData(String key, PostModel value) async {
    var posts = getPostsData(key);
    posts.remove(value);
    await setPostsData(key, posts);
  }
}
