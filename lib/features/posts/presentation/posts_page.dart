import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_project/app/http/dio_client.dart';
import 'package:practice_project/features/favorites/domain/bloc/favorites_bloc.dart';
import 'package:practice_project/features/posts/data/model/post_model.dart';
import 'package:practice_project/features/posts/data/repositories/posts_repository.dart';
import 'package:practice_project/features/posts/domain/bloc/bloc/posts_bloc.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(PostsRepository(DioClient())),
      child: const _PostsPage(),
    );
  }
}

class _PostsPage extends StatelessWidget {
  const _PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: context.read<PostsBloc>()..add(const PostsEvent.getData()),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () => throw Exception(),
                child: const Text("Throw Test Exception"),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              CupertinoIcons.heart_fill,
              color: Colors.pink,
            ),
            onPressed: () async {
              context.push('/favorites');
            },
          ),
          body: state.when(
            empty: () {
              return const Text('No elements');
            },
            error: (error, stackTrace) {
              return Text(error.toString());
            },
            loaded: (posts) {
              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemBuilder: (context, index) {
                  return PostCard(
                    post: posts[index],
                  );
                },
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          bool isFavorite = context.read<FavoritesBloc>().isFavorite(post);

          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                context
                    .read<FavoritesBloc>()
                    .add(FavoritesEvent.removeData(post));
              } else {
                context.read<FavoritesBloc>().add(FavoritesEvent.addData(post));
              }
            },
          );
        },
      ),
      onTap: () => context.push('/post/${post.id}'),
      title: Text(
        post.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(post.body),
    );
  }
}
