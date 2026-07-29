import '../../domain/entities/character_entity.dart';

class LocationRefModel extends LocationRefEntity {
  const LocationRefModel({required super.name, required super.url});

  factory LocationRefModel.fromJson(Map<String, dynamic> json) {
    return LocationRefModel(
      name: json['name'] as String? ?? 'unknown',
      url: json['url'] as String? ?? '',
    );
  }
}

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
    required super.episode,
    required super.url,
    required super.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? 'unknown',
      origin: LocationRefModel.fromJson(
        json['origin'] as Map<String, dynamic>? ?? const {},
      ),
      location: LocationRefModel.fromJson(
        json['location'] as Map<String, dynamic>? ?? const {},
      ),
      image: json['image'] as String? ?? '',
      episode: (json['episode'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      url: json['url'] as String? ?? '',
      created: DateTime.tryParse(json['created'] as String? ?? '') ?? DateTime(1970),
    );
  }
}