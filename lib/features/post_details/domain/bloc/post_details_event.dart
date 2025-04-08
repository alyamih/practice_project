part of 'post_details_bloc.dart';

@freezed
class PostDetailsEvent with _$PostDetailsEvent {
  const factory PostDetailsEvent.getData(int postId) = _GetData;
}
