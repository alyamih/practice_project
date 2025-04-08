import 'package:practice_project/app/http/dio_client.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

class PostsRepository {
  final DioClient _dioClient;

  PostsRepository(this._dioClient);

  Future<List<PostModel>> getPosts() async {
    final posts = await _dioClient.dio.get<List>('posts');
    return posts.data
            ?.map(
              (e) => PostModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
  }
}
