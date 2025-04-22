import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_project/features/favorites/data/repositories/i_favorite_repository.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

class FavoriteFirebaseRewpository implements IFavoriteRepository {
  @override
  FirebaseFirestore get dataSource => FirebaseFirestore.instance;

  @override
  Future<List<PostModel>> getData() async {
    return dataSource.collection('favorites').get().then(
      (value) {
        return value.docs
            .map(
              (e) => PostModel.fromJson(e.data()),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> postData(List<PostModel> posts) async {
    for (var post in posts) {
      dataSource.collection('favorites').add(post.toJson());
    }
  }

  @override
  Future<void> putData(PostModel post) async {
    dataSource.collection('favorites').add(post.toJson());
  }
}
