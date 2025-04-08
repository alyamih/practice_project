import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_project/app/http/dio_client.dart';
import 'package:practice_project/features/post_details/data/repositories/post_details_repository.dart';
import 'package:practice_project/features/post_details/domain/bloc/post_details_bloc.dart';
import 'package:practice_project/features/post_details/presentation/widgets/comment_card.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailsBloc(PostDetailsRepository(DioClient())),
      child: _PostDetailsPage(
        postId: postId,
      ),
    );
  }
}

class _PostDetailsPage extends StatelessWidget {
  const _PostDetailsPage({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      bloc: context.read<PostDetailsBloc>()
        ..add(PostDetailsEvent.getData(postId)),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: state.when(
            empty: () {
              return const Text('No elements');
            },
            error: (error, stackTrace) {
              return Text(error.toString());
            },
            loaded: (comments) {
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 35, 16, 30),
                itemCount: comments.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemBuilder: (context, index) {
                  return CommentCard(
                    comment: comments[index],
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
