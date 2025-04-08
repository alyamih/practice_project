import 'package:practice_project/app/http/dio_client.dart';
import 'package:practice_project/features/post_details/data/model/comment_model.dart';

class PostDetailsRepository {
  final DioClient _dioClient;

  PostDetailsRepository(this._dioClient);

  Future<List<CommentModel>> getComments(int postId) async {
    final comments = await _dioClient.dio
        .get<List>('comments', queryParameters: {'postId': postId});
    return comments.data
            ?.map(
              (e) => CommentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
  }

  Future<List<CommentModel>> getCommentsAlt(int postId) async {
    final comments = await _dioClient.dio.get<List>('posts/$postId/comments');
    return comments.data
            ?.map(
              (e) => CommentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
  }
}
