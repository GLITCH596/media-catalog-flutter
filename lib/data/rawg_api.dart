import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_catalog_learning/models/game.dart';
import 'package:movie_catalog_learning/secrets.dart';

class RawgApi {
  Future<List<Game>> fetchPopularGames() =>
      _getGames(Uri.https('api.rawg.io', '/api/games', {
        'key': rawgKey,
        'page_size': '20',
        })
      );
  
  Future<List<Game>> searchGames(String query) => _getGames(
    Uri.https('api.rawg.io', '/api/games', {
      'key': rawgKey,
      'search': query,
      'page_size': '50',}),
  );

  Future<List<Game>> _getGames(Uri uri) async {
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Ошибка RAWG: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results
        .map((json) => Game.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}