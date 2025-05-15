import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/features/favorites/data/repositories/i_favorite_repository.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

class FavoriteFirebaseRepository implements IFavoriteRepository {
  @override
  FirebaseFirestore get dataSource => FirebaseFirestore.instance;

  @override
  Future<List<PostModel>> getData() async {
    return dataSource
        .collection('favorites')
        .where('favoriteUserId',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (value) {
        return value.docs.map(
          (e) {
            return PostModel.fromJson(e.data());
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> postData(List<PostModel> posts) async {
    for (var post in posts) {
      dataSource
          .collection('favorites')
          .doc('${post.id}_${FirebaseAuth.instance.currentUser?.uid}')
          .set(post
              .copyWith(favoriteUserId: FirebaseAuth.instance.currentUser?.uid)
              .toJson());
    }
  }

  @override
  Future<PostModel> putData(PostModel post) async {
    await dataSource
        .collection('favorites')
        .doc('${post.id}_${FirebaseAuth.instance.currentUser?.uid}')
        .set(post
            .copyWith(favoriteUserId: FirebaseAuth.instance.currentUser?.uid)
            .toJson());

    return post.copyWith(
        favoriteUserId: FirebaseAuth.instance.currentUser?.uid);
  }

  @override
  Future<void> deleteData(PostModel post) async {
    dataSource
        .collection('favorites')
        .doc('${post.id}_${FirebaseAuth.instance.currentUser?.uid}')
        .delete();
  }
}
