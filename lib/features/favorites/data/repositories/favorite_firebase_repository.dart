import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/features/favorites/data/repositories/i_favorite_repository.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

class FavoriteFirebaseRepository implements IFavoriteRepository {
  @override
  FirebaseFirestore get dataSource => FirebaseFirestore.instance;

  @override
  Future<List<PostModel>> getData() async {
    return dataSource.collection('favorites').get().then(
      (value) {
        return value.docs.map(
          (e) {
            // log(e.data().toString());
            return PostModel.fromJson(e.data()).copyWith(docId: e.id);
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> postData(List<PostModel> posts) async {
    for (var post in posts) {
      dataSource.collection('favorites').add(post
          .copyWith(favoriteUserId: FirebaseAuth.instance.currentUser?.uid)
          .toJson());
    }
  }

  @override
  Future<PostModel> putData(PostModel post) async {
    var currentCollection =
        await dataSource.collection('favorites').add(post.toJson());
    var newPost = await currentCollection.get();
    return PostModel.fromJson(newPost.data()!).copyWith(
        favoriteUserId: FirebaseAuth.instance.currentUser?.uid,
        docId: newPost.id);
  }

  @override
  Future<void> deleteData(PostModel post) async {
    dataSource.collection('favorites').doc(post.docId).delete();
  }
}
