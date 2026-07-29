import '../../domain/entities/characters_result_entity.dart';
import 'character_model.dart';
class CharactersInfoModel extends CharactersInfoEntity {
  const CharactersInfoModel({
    required super.count,
    required super.pages,
    super.next,
    super.prev,
  });

  factory CharactersInfoModel.fromJson(Map<String, dynamic> json) {
    return CharactersInfoModel(
      count: json['count'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }

  factory CharactersInfoModel.empty() {
    return const CharactersInfoModel(count: 0, pages: 0, next: null, prev: null);
  }
}

class CharactersResultModel extends CharactersResultEntity {
  const CharactersResultModel({
    required List<CharacterModel> super.characters,
    required CharactersInfoModel super.info,
  });

  factory CharactersResultModel.fromJson(Map<String, dynamic> json) {
    return CharactersResultModel(
      characters: (json['results'] as List<dynamic>? ?? const [])
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: CharactersInfoModel.fromJson(
        json['info'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  factory CharactersResultModel.empty() {
    return CharactersResultModel(
      characters: const [],
      info: CharactersInfoModel.empty(),
    );
  }
}