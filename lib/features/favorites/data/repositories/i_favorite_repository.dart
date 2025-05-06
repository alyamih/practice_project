import 'package:practice_project/features/posts/data/model/post_model.dart';

abstract interface class IFavoriteRepository {
  dynamic get dataSource;
  Future<void> postData(List<PostModel> posts);
  Future<List<PostModel>> getData();
  Future<void> putData(PostModel post);
  Future<void> deleteData(PostModel post);
}
