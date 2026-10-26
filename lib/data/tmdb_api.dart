import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_catalog_learning/models/movie.dart';
import 'package:movie_catalog_learning/secrets.dart';

class TmdbApi {
  Future<List<Movie>> fetchPopularMovies() =>
      _getMovies(Uri.parse('https://api.themoviedb.org/3/movie/popular'));
  
  Future<List<Movie>> searchMovies(String query) => _getMovies(
    Uri.http('api.themoviedb.org', '/3/search/movie', {'query': query}),
  );

  Future<List<Movie>> _getMovies(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $tmdbToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка TMDB: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}