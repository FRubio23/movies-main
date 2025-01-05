import 'dart:convert';
class Actor {
  int id;
  String name;
  String profilePath;
  String? biography;
  String? birthday;
  String? deathday;
  String? placeOfBirth;
  double popularity;
  List<String> alsoKnownAs;
  String knownForDepartment;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    required this.popularity,
    required this.alsoKnownAs,
    required this.knownForDepartment,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] as int,
      name: map['name'] ?? '',
      profilePath: map['profile_path'] ?? '',
      biography: map['biography'],
      birthday: map['birthday'],
      deathday: map['deathday'],
      placeOfBirth: map['place_of_birth'],
      popularity: map['popularity']?.toDouble() ?? 0.0,
      alsoKnownAs: List<String>.from(map['also_known_as'] ?? []),
      knownForDepartment: map['known_for_department'] ?? '',
    );
  }
  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}
