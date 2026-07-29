import 'package:equatable/equatable.dart';

class LocationRefEntity extends Equatable {
  final String name;
  final String url;

  const LocationRefEntity({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status; // 'Alive' | 'Dead' | 'unknown'
  final String species;
  final String type;
  final String gender; // 'Female' | 'Male' | 'Genderless' | 'unknown'
  final LocationRefEntity origin;
  final LocationRefEntity location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        origin,
        location,
        image,
        episode,
        url,
        created,
      ];
}
