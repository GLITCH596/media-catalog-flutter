import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_catalog_learning/data/rawg_api.dart';
import '../models/game.dart';

// События
sealed class GamesEvent {}

class GamesLoadRequested extends GamesEvent {}

class GamesSearchSubmitted extends GamesEvent {
  final String query;
  GamesSearchSubmitted(this.query);
}

// Состояния
sealed class GamesState {}

class GamesLoading extends GamesState {}

class GamesLoaded extends GamesState {
  final List<Game> movies;
  GamesLoaded(this.movies);
}

class GamesError extends GamesState {
  final String message;
  GamesError(this.message);
}

// BLoC
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final RawgApi api;

  GamesBloc(this.api) : super(GamesLoading()) {
    on<GamesLoadRequested>((event, emit) => _run(emit, api.fetchPopularGames));

    on<GamesSearchSubmitted>((event, emit) {
      final query = event.query.trim();
      if (query.isEmpty) return _run(emit, api.fetchPopularGames);
      return _run(emit, () => api.searchGames(query));
    });
  }

  Future<void> _run(
    Emitter<GamesState> emit,
    Future<List<Game>> Function() fetch,
  ) async {
    emit(GamesLoading());
    try {
      final movies = await fetch();
      emit(GamesLoaded(movies));
    } catch (e) {
      emit(GamesError(e.toString()));
    }
  }
}
