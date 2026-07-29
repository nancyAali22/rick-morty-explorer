import 'package:equatable/equatable.dart';

import 'character_entity.dart';

class CharactersInfoEntity extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const CharactersInfoEntity({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  bool get hasNextPage => next != null;

  @override
  List<Object?> get props => [count, pages, next, prev];
}

class CharactersResultEntity extends Equatable {
  final List<CharacterEntity> characters;
  final CharactersInfoEntity info;

  const CharactersResultEntity({required this.characters, required this.info});

  @override
  List<Object?> get props => [characters, info];
}
