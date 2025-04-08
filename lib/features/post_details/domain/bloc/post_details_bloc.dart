import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:practice_project/features/post_details/data/model/comment_model.dart';
import 'package:practice_project/features/post_details/data/repositories/post_details_repository.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';
part 'post_details_bloc.freezed.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  PostDetailsBloc(this.repository) : super(const _Loading()) {
    on<_GetData>(_onGetData);
  }
  PostDetailsRepository repository;
  FutureOr<void> _onGetData(
      _GetData event, Emitter<PostDetailsState> emit) async {
    emit(const _Loading());
    try {
      final data = await repository.getComments(event.postId);
      if (data.isEmpty) {
        return emit(const _Empty());
      }
      emit(_Loaded(posts: data));
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace);
      emit(_Error(error: e, stackTrace: stackTrace));
    }
    return null;
  }
}
