import 'package:flutter/material.dart';
import 'package:movie_catalog_learning/bloc/movies_bloc.dart';
import 'package:movie_catalog_learning/data/tmdb_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesBloc(TmdbApi())..add(MoviesLoadRequested()),
      child: const MoviesView(),

    );
  }
}

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Популярные фильмы')),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsetsGeometry.only(left: 8, right: 8, top: 8),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (query) =>
                  context.read<MoviesBloc>().add(MoviesSearchSubmitted(query)),
              decoration: InputDecoration(
                hintText: 'Find a movie',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MoviesError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ошибка: ${state.message}'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<MoviesBloc>().add(MoviesLoadRequested()),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final movies = (state as MoviesLoaded).movies;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: movie.posterPath == null
                          ? const Icon(Icons.movie)
                          : Image.network(
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}'),
                      title: Text(movie.title),
                      subtitle: Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(movie.voteAverage.toStringAsFixed(1)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
