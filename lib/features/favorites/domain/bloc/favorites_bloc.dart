import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:practice_project/features/favorites/data/repositories/favorite_firebase_repository.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';
part 'favorites_bloc.freezed.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this.favoriteRepository) : super(const _Loading()) {
    on<_GetData>(_onGetData);
    on<_AddData>(_onAddData);
    on<_RemoveData>(_onRemoveData);
    initListenersToExternalStreams();
  }
  FavoriteFirebaseRepository favoriteRepository;
  late StreamSubscription userAuthStream;
  bool isFavorite(PostModel post) {
    return state.maybeMap(
      orElse: () => false,
      loaded: (value) => value.posts
          .where(
            (element) => element.id == post.id,
          )
          .isNotEmpty,
    );
  }

  FutureOr<void> _onGetData(
      _GetData event, Emitter<FavoritesState> emit) async {
    emit(const _Loading());
    try {
      final data = await favoriteRepository.getData();
      if (data.isEmpty) {
        return emit(const _Empty());
      }
      emit(_Loaded(posts: data));
    } on FirebaseException catch (e, stackTrace) {
      emit(const _NotAuthed());
    } catch (e, stackTrace) {
      log('${e.runtimeType}', error: e, stackTrace: stackTrace);
      emit(_Error(error: e, stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onAddData(
      _AddData event, Emitter<FavoritesState> emit) async {
    try {
      var newPost = await favoriteRepository.putData(event.post);

      emit(_Loaded(
          posts: state.maybeWhen(
        orElse: () => [newPost],
        loaded: (posts) => [newPost, ...posts],
      )));
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace);
      emit(_Error(error: e, stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onRemoveData(
      _RemoveData event, Emitter<FavoritesState> emit) async {
    try {
      var favoritePosts = state.maybeWhen(
        orElse: () => <PostModel>[],
        loaded: (posts) => [...posts],
      );
      var newFavPosts = favoritePosts
          .where(
            (element) => element.id != event.post.id,
          )
          .toList();
      await favoriteRepository.deleteData(event.post);
      emit(_Loaded(posts: newFavPosts));
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace);
      emit(_Error(error: e, stackTrace: stackTrace));
    }
  }

  @override
  void onChange(Change<FavoritesState> change) {
    log('${change.currentState}\n\n${change.nextState}');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    userAuthStream.cancel();
    return super.close();
  }

  void initListenersToExternalStreams() {
    userAuthStream = FirebaseAuth.instance.userChanges().listen(
          (event) => this.add(const _GetData()),
        );
  }
}
