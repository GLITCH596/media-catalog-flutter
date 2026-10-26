class Game {
  final int id;
  final String name;
  final String released;
  final String? backgroundImage;
  final double rating;

  Game({
    required this.id,
    required this.name,
    required this.released,
    this.backgroundImage,
    required this.rating,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      name: json['name'] as String,
      released: json['released'] as String? ?? '',
      backgroundImage: json['background_image'] as String?,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
