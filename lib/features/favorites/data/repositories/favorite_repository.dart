import 'package:practice_project/app/utils/services/extensions/sp_service_extension.dart';
import 'package:practice_project/app/utils/services/sp_service.dart';
import 'package:practice_project/core/shared_pref_keys.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

class FavoriteRepository {
  Future<SpService> get dataSource async => await SpService.instance;
  Future<void> postData(List<PostModel> posts) async {
    (await dataSource).setPostsData(SharedPrefKeys.favoritePosts, posts);
  }

  Future<List<PostModel>> getData() async {
    var posts = (await dataSource).getPostsData(SharedPrefKeys.favoritePosts);
    return posts;
  }

  Future<void> putData(PostModel post) async {
    (await dataSource).addPostData(SharedPrefKeys.favoritePosts, post);
  }
}
