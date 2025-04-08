part of 'post_details_bloc.dart';

@freezed
class PostDetailsState with _$PostDetailsState {
  const factory PostDetailsState.loading() = _Loading;
  const factory PostDetailsState.loaded({required List<CommentModel> posts}) =
      _Loaded;
  const factory PostDetailsState.error(
      {required Object error, StackTrace? stackTrace}) = _Error;
  const factory PostDetailsState.empty() = _Empty;
}
