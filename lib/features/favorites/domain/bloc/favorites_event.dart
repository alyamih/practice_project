part of 'favorites_bloc.dart';

@freezed
class FavoritesEvent with _$FavoritesEvent {
  const factory FavoritesEvent.getData() = _GetData;
  const factory FavoritesEvent.addData(PostModel post) = _AddData;
  const factory FavoritesEvent.removeData(PostModel post) = _RemoveData;
}
