import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_catalog_learning/models/game.dart';
import 'package:movie_catalog_learning/secrets.dart';

class RawgApi {
  Future<List<Game>> fetchPopularGames() {
    final now = DateTime.now();
    final yearAgo = DateTime(now.year - 1, now.month, now.day);
    return _getGames(_gamesUri({
      // вышли за последний год; формат даты ГГГГ-ММ-ДД
      'dates': '${_date(yearAgo)},${_date(now)}',
      // -added: сначала те, что чаще всего добавляют в свои библиотеки
      'ordering': '-added',
    }));
  }

// Первые 10 символов ISO-строки это и есть ГГГГ-ММ-ДД
  String _date(DateTime d) => d.toIso8601String().substring(0, 10);

  Future<List<Game>> searchGames(String query) =>
      _getGames(_gamesUri({'search': query}));

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

  Uri _gamesUri([Map<String, String> extra = const {}]) => Uri.https(
    'api.rawg.io',
    '/api/games',
    {'key': rawgKey, 'page_size': '30', ...extra},
  );
}
