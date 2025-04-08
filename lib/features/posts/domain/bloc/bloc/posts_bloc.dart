import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';
import 'package:practice_project/features/posts/data/repositories/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';
part 'posts_bloc.freezed.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(this.repository) : super(const _Loading()) {
    on<_GetData>(_onGetData);
  }
  PostsRepository repository;
  FutureOr<void> _onGetData(_GetData event, Emitter<PostsState> emit) async {
    emit(const _Loading());
    try {
      final data = await repository.getPosts();
      if (data.isEmpty) {
        return emit(const _Empty());
      }
      emit(_Loaded(posts: data));
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace);
      emit(_Error(error: e, stackTrace: stackTrace));
    }
  }
}
