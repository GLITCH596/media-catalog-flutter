import 'package:flutter/material.dart';
import 'package:movie_catalog_learning/bloc/games_bloc.dart';
import 'package:movie_catalog_learning/data/rawg_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamesBloc(RawgApi())..add(GamesLoadRequested()),
      child: const MoviesView(),

    );
  }
}

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular games')),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsetsGeometry.only(left: 8, right: 8, top: 8),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (query) =>
                  context.read<GamesBloc>().add(GamesSearchSubmitted(query)),
              decoration: InputDecoration(
                hintText: 'Find a game',
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
            child: BlocBuilder<GamesBloc, GamesState>(
              builder: (context, state) {
                if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GamesError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ошибка: ${state.message}'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<GamesBloc>().add(GamesLoadRequested()),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final games = (state as GamesLoaded).movies;
                return ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return ListTile(
                      leading: game.backgroundImage == null
                          ? const Icon(Icons.sports_esports)
                          : Image.network(
                        game.backgroundImage!,
                        width: 80,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.sports_esports),
                      ),
                      title: Text(game.name),
                      subtitle: Text(game.released),
                      trailing: Text(game.rating.toStringAsFixed(1)),
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
