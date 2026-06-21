// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedSessionCollection on Isar {
  IsarCollection<SavedSession> get savedSessions => this.collection();
}

const SavedSessionSchema = CollectionSchema(
  name: r'SavedSession',
  id: 6546359339946958477,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'messageCount': PropertySchema(
      id: 1,
      name: r'messageCount',
      type: IsarType.long,
    ),
    r'preview': PropertySchema(id: 2, name: r'preview', type: IsarType.string),
    r'sectionLabel': PropertySchema(
      id: 3,
      name: r'sectionLabel',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 4,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 5, name: r'title', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.string,
    ),
    r'updatedLabel': PropertySchema(
      id: 7,
      name: r'updatedLabel',
      type: IsarType.string,
    ),
  },

  estimateSize: _savedSessionEstimateSize,
  serialize: _savedSessionSerialize,
  deserialize: _savedSessionDeserialize,
  deserializeProp: _savedSessionDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _savedSessionGetId,
  getLinks: _savedSessionGetLinks,
  attach: _savedSessionAttach,
  version: '3.3.2',
);

int _savedSessionEstimateSize(
  SavedSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.createdAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.preview.length * 3;
  bytesCount += 3 + object.sectionLabel.length * 3;
  bytesCount += 3 + object.sessionId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.updatedAt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.updatedLabel.length * 3;
  return bytesCount;
}

void _savedSessionSerialize(
  SavedSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.messageCount);
  writer.writeString(offsets[2], object.preview);
  writer.writeString(offsets[3], object.sectionLabel);
  writer.writeString(offsets[4], object.sessionId);
  writer.writeString(offsets[5], object.title);
  writer.writeString(offsets[6], object.updatedAt);
  writer.writeString(offsets[7], object.updatedLabel);
}

SavedSession _savedSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedSession();
  object.createdAt = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.messageCount = reader.readLong(offsets[1]);
  object.preview = reader.readString(offsets[2]);
  object.sectionLabel = reader.readString(offsets[3]);
  object.sessionId = reader.readString(offsets[4]);
  object.title = reader.readString(offsets[5]);
  object.updatedAt = reader.readStringOrNull(offsets[6]);
  object.updatedLabel = reader.readString(offsets[7]);
  return object;
}

P _savedSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedSessionGetId(SavedSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedSessionGetLinks(SavedSession object) {
  return [];
}

void _savedSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  SavedSession object,
) {
  object.id = id;
}

extension SavedSessionByIndex on IsarCollection<SavedSession> {
  Future<SavedSession?> getBySessionId(String sessionId) {
    return getByIndex(r'sessionId', [sessionId]);
  }

  SavedSession? getBySessionIdSync(String sessionId) {
    return getByIndexSync(r'sessionId', [sessionId]);
  }

  Future<bool> deleteBySessionId(String sessionId) {
    return deleteByIndex(r'sessionId', [sessionId]);
  }

  bool deleteBySessionIdSync(String sessionId) {
    return deleteByIndexSync(r'sessionId', [sessionId]);
  }

  Future<List<SavedSession?>> getAllBySessionId(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sessionId', values);
  }

  List<SavedSession?> getAllBySessionIdSync(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sessionId', values);
  }

  Future<int> deleteAllBySessionId(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sessionId', values);
  }

  int deleteAllBySessionIdSync(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sessionId', values);
  }

  Future<Id> putBySessionId(SavedSession object) {
    return putByIndex(r'sessionId', object);
  }

  Id putBySessionIdSync(SavedSession object, {bool saveLinks = true}) {
    return putByIndexSync(r'sessionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySessionId(List<SavedSession> objects) {
    return putAllByIndex(r'sessionId', objects);
  }

  List<Id> putAllBySessionIdSync(
    List<SavedSession> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'sessionId', objects, saveLinks: saveLinks);
  }
}

extension SavedSessionQueryWhereSort
    on QueryBuilder<SavedSession, SavedSession, QWhere> {
  QueryBuilder<SavedSession, SavedSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedSessionQueryWhere
    on QueryBuilder<SavedSession, SavedSession, QWhereClause> {
  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause> sessionIdEqualTo(
    String sessionId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'sessionId', value: [sessionId]),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterWhereClause>
  sessionIdNotEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [],
                upper: [sessionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [sessionId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [sessionId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [],
                upper: [sessionId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension SavedSessionQueryFilter
    on QueryBuilder<SavedSession, SavedSession, QFilterCondition> {
  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'createdAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'createdAt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'createdAt', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  messageCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'messageCount', value: value),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  messageCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'messageCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  messageCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'messageCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  messageCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'messageCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preview',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preview',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preview',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preview', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  previewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'preview', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sectionLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sectionLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sectionLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sectionLabel', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sectionLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sectionLabel', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sessionId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionId', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sessionId', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'updatedAt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'updatedAt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'updatedAt', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'updatedLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'updatedLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedLabel', value: ''),
      );
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterFilterCondition>
  updatedLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'updatedLabel', value: ''),
      );
    });
  }
}

extension SavedSessionQueryObject
    on QueryBuilder<SavedSession, SavedSession, QFilterCondition> {}

extension SavedSessionQueryLinks
    on QueryBuilder<SavedSession, SavedSession, QFilterCondition> {}

extension SavedSessionQuerySortBy
    on QueryBuilder<SavedSession, SavedSession, QSortBy> {
  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByMessageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageCount', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  sortByMessageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageCount', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortBySectionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionLabel', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  sortBySectionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionLabel', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> sortByUpdatedLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedLabel', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  sortByUpdatedLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedLabel', Sort.desc);
    });
  }
}

extension SavedSessionQuerySortThenBy
    on QueryBuilder<SavedSession, SavedSession, QSortThenBy> {
  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByMessageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageCount', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  thenByMessageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageCount', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenBySectionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionLabel', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  thenBySectionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionLabel', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy> thenByUpdatedLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedLabel', Sort.asc);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QAfterSortBy>
  thenByUpdatedLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedLabel', Sort.desc);
    });
  }
}

extension SavedSessionQueryWhereDistinct
    on QueryBuilder<SavedSession, SavedSession, QDistinct> {
  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByCreatedAt({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByMessageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageCount');
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByPreview({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctBySectionLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectionLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctBySessionId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByUpdatedAt({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSession, SavedSession, QDistinct> distinctByUpdatedLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedLabel', caseSensitive: caseSensitive);
    });
  }
}

extension SavedSessionQueryProperty
    on QueryBuilder<SavedSession, SavedSession, QQueryProperty> {
  QueryBuilder<SavedSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedSession, String?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SavedSession, int, QQueryOperations> messageCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageCount');
    });
  }

  QueryBuilder<SavedSession, String, QQueryOperations> previewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preview');
    });
  }

  QueryBuilder<SavedSession, String, QQueryOperations> sectionLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectionLabel');
    });
  }

  QueryBuilder<SavedSession, String, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<SavedSession, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<SavedSession, String?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<SavedSession, String, QQueryOperations> updatedLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedLabel');
    });
  }
}
