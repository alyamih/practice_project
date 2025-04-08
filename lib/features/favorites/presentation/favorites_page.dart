import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_project/features/favorites/domain/bloc/favorites_bloc.dart';
import 'package:practice_project/features/posts/presentation/posts_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: context.read<FavoritesBloc>()..add(const FavoritesEvent.getData()),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
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
