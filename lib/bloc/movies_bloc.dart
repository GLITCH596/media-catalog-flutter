import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_catalog_learning/data/tmdb_api.dart';

import '../models/movie.dart';

// События
sealed class MoviesEvent {}

class MoviesLoadRequested extends MoviesEvent {}

class MoviesSearchSubmitted extends MoviesEvent {
  final String query;
  MoviesSearchSubmitted(this.query);
}

// Состояния
sealed class MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  MoviesLoaded(this.movies);
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}

// BLoC
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final TmdbApi api;

  MoviesBloc(this.api) : super(MoviesLoading()) {
    on<MoviesLoadRequested>((event, emit) => _run(emit, api.fetchPopularMovies));

    on<MoviesSearchSubmitted>((event, emit) {
      final query = event.query.trim();
      if (query.isEmpty) return _run(emit, api.fetchPopularMovies);
      return _run(emit, () => api.searchMovies(query));
    });
  }

  Future<void> _run(
    Emitter<MoviesState> emit,
    Future<List<Movie>> Function() fetch,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await fetch();
      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }
}
