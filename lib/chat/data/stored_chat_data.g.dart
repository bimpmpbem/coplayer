// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_chat_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStoredChatItemCollection on Isar {
  IsarCollection<StoredChatItem> get storedChatItems => this.collection();
}

const StoredChatItemSchema = CollectionSchema(
  name: r'StoredChatItem',
  id: -2392058906350303494,
  properties: {
    r'authorId': PropertySchema(
      id: 0,
      name: r'authorId',
      type: IsarType.string,
    ),
    r'index': PropertySchema(
      id: 1,
      name: r'index',
      type: IsarType.long,
    ),
    r'itemId': PropertySchema(
      id: 2,
      name: r'itemId',
      type: IsarType.string,
    ),
    r'itemJsonString': PropertySchema(
      id: 3,
      name: r'itemJsonString',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 4,
      name: r'source',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.long,
    )
  },
  estimateSize: _storedChatItemEstimateSize,
  serialize: _storedChatItemSerialize,
  deserialize: _storedChatItemDeserialize,
  deserializeProp: _storedChatItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'source': IndexSchema(
      id: -836881197531269605,
      name: r'source',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'index': IndexSchema(
      id: -5425839060849557016,
      name: r'index',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'index',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _storedChatItemGetId,
  getLinks: _storedChatItemGetLinks,
  attach: _storedChatItemAttach,
  version: '3.1.0+1',
);

int _storedChatItemEstimateSize(
  StoredChatItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.authorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemJsonString.length * 3;
  bytesCount += 3 + object.source.length * 3;
  return bytesCount;
}

void _storedChatItemSerialize(
  StoredChatItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.authorId);
  writer.writeLong(offsets[1], object.index);
  writer.writeString(offsets[2], object.itemId);
  writer.writeString(offsets[3], object.itemJsonString);
  writer.writeString(offsets[4], object.source);
  writer.writeLong(offsets[5], object.timestamp);
}

StoredChatItem _storedChatItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StoredChatItem();
  object.authorId = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.index = reader.readLong(offsets[1]);
  object.itemId = reader.readStringOrNull(offsets[2]);
  object.itemJsonString = reader.readString(offsets[3]);
  object.source = reader.readString(offsets[4]);
  object.timestamp = reader.readLong(offsets[5]);
  return object;
}

P _storedChatItemDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _storedChatItemGetId(StoredChatItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storedChatItemGetLinks(StoredChatItem object) {
  return [];
}

void _storedChatItemAttach(
    IsarCollection<dynamic> col, Id id, StoredChatItem object) {
  object.id = id;
}

extension StoredChatItemQueryWhereSort
    on QueryBuilder<StoredChatItem, StoredChatItem, QWhere> {
  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhere> anySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'source'),
      );
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhere> anyIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'index'),
      );
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension StoredChatItemQueryWhere
    on QueryBuilder<StoredChatItem, StoredChatItem, QWhereClause> {
  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> sourceEqualTo(
      String source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [source],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceNotEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceGreaterThan(
    String source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [source],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceLessThan(
    String source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [],
        upper: [source],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> sourceBetween(
    String lowerSource,
    String upperSource, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [lowerSource],
        includeLower: includeLower,
        upper: [upperSource],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceStartsWith(String SourcePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [SourcePrefix],
        upper: ['$SourcePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [''],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'source',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'source',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'source',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'source',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> indexEqualTo(
      int index) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'index',
        value: [index],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      indexNotEqualTo(int index) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [],
              upper: [index],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [index],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [index],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [],
              upper: [index],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      indexGreaterThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [index],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> indexLessThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [],
        upper: [index],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause> indexBetween(
    int lowerIndex,
    int upperIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [lowerIndex],
        includeLower: includeLower,
        upper: [upperIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      timestampEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      timestampNotEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      timestampGreaterThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      timestampLessThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterWhereClause>
      timestampBetween(
    int lowerTimestamp,
    int upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoredChatItemQueryFilter
    on QueryBuilder<StoredChatItem, StoredChatItem, QFilterCondition> {
  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'authorId',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'authorId',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      authorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authorId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      indexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      indexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemId',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemId',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemJsonString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemJsonString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemJsonString',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      itemJsonStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemJsonString',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      timestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      timestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterFilterCondition>
      timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoredChatItemQueryObject
    on QueryBuilder<StoredChatItem, StoredChatItem, QFilterCondition> {}

extension StoredChatItemQueryLinks
    on QueryBuilder<StoredChatItem, StoredChatItem, QFilterCondition> {}

extension StoredChatItemQuerySortBy
    on QueryBuilder<StoredChatItem, StoredChatItem, QSortBy> {
  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortByAuthorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortByAuthorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortByItemJsonString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemJsonString', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortByItemJsonStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemJsonString', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension StoredChatItemQuerySortThenBy
    on QueryBuilder<StoredChatItem, StoredChatItem, QSortThenBy> {
  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByAuthorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenByAuthorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenByItemJsonString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemJsonString', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenByItemJsonStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemJsonString', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension StoredChatItemQueryWhereDistinct
    on QueryBuilder<StoredChatItem, StoredChatItem, QDistinct> {
  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct> distinctByAuthorId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct> distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct> distinctByItemId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct>
      distinctByItemJsonString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemJsonString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatItem, StoredChatItem, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension StoredChatItemQueryProperty
    on QueryBuilder<StoredChatItem, StoredChatItem, QQueryProperty> {
  QueryBuilder<StoredChatItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StoredChatItem, String?, QQueryOperations> authorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authorId');
    });
  }

  QueryBuilder<StoredChatItem, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<StoredChatItem, String?, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<StoredChatItem, String, QQueryOperations>
      itemJsonStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemJsonString');
    });
  }

  QueryBuilder<StoredChatItem, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<StoredChatItem, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStoredChatTickerCollection on Isar {
  IsarCollection<StoredChatTicker> get storedChatTickers => this.collection();
}

const StoredChatTickerSchema = CollectionSchema(
  name: r'StoredChatTicker',
  id: -5046182329091858731,
  properties: {
    r'authorId': PropertySchema(
      id: 0,
      name: r'authorId',
      type: IsarType.string,
    ),
    r'endTimestamp': PropertySchema(
      id: 1,
      name: r'endTimestamp',
      type: IsarType.long,
    ),
    r'index': PropertySchema(
      id: 2,
      name: r'index',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 3,
      name: r'source',
      type: IsarType.string,
    ),
    r'tickerJsonString': PropertySchema(
      id: 4,
      name: r'tickerJsonString',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.long,
    )
  },
  estimateSize: _storedChatTickerEstimateSize,
  serialize: _storedChatTickerSerialize,
  deserialize: _storedChatTickerDeserialize,
  deserializeProp: _storedChatTickerDeserializeProp,
  idName: r'id',
  indexes: {
    r'source': IndexSchema(
      id: -836881197531269605,
      name: r'source',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'index': IndexSchema(
      id: -5425839060849557016,
      name: r'index',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'index',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'endTimestamp': IndexSchema(
      id: 2728025042974280553,
      name: r'endTimestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'endTimestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _storedChatTickerGetId,
  getLinks: _storedChatTickerGetLinks,
  attach: _storedChatTickerAttach,
  version: '3.1.0+1',
);

int _storedChatTickerEstimateSize(
  StoredChatTicker object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.authorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.tickerJsonString.length * 3;
  return bytesCount;
}

void _storedChatTickerSerialize(
  StoredChatTicker object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.authorId);
  writer.writeLong(offsets[1], object.endTimestamp);
  writer.writeLong(offsets[2], object.index);
  writer.writeString(offsets[3], object.source);
  writer.writeString(offsets[4], object.tickerJsonString);
  writer.writeLong(offsets[5], object.timestamp);
}

StoredChatTicker _storedChatTickerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StoredChatTicker();
  object.authorId = reader.readStringOrNull(offsets[0]);
  object.endTimestamp = reader.readLong(offsets[1]);
  object.id = id;
  object.index = reader.readLong(offsets[2]);
  object.source = reader.readString(offsets[3]);
  object.tickerJsonString = reader.readString(offsets[4]);
  object.timestamp = reader.readLong(offsets[5]);
  return object;
}

P _storedChatTickerDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _storedChatTickerGetId(StoredChatTicker object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storedChatTickerGetLinks(StoredChatTicker object) {
  return [];
}

void _storedChatTickerAttach(
    IsarCollection<dynamic> col, Id id, StoredChatTicker object) {
  object.id = id;
}

extension StoredChatTickerQueryWhereSort
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QWhere> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhere> anySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'source'),
      );
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhere> anyIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'index'),
      );
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhere>
      anyEndTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'endTimestamp'),
      );
    });
  }
}

extension StoredChatTickerQueryWhere
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QWhereClause> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [source],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceNotEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceGreaterThan(
    String source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [source],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceLessThan(
    String source, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [],
        upper: [source],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceBetween(
    String lowerSource,
    String upperSource, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [lowerSource],
        includeLower: includeLower,
        upper: [upperSource],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceStartsWith(String SourcePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'source',
        lower: [SourcePrefix],
        upper: ['$SourcePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [''],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'source',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'source',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'source',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'source',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      indexEqualTo(int index) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'index',
        value: [index],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      indexNotEqualTo(int index) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [],
              upper: [index],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [index],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [index],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'index',
              lower: [],
              upper: [index],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      indexGreaterThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [index],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      indexLessThan(
    int index, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [],
        upper: [index],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      indexBetween(
    int lowerIndex,
    int upperIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'index',
        lower: [lowerIndex],
        includeLower: includeLower,
        upper: [upperIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      timestampEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      timestampNotEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      timestampGreaterThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      timestampLessThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      timestampBetween(
    int lowerTimestamp,
    int upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      endTimestampEqualTo(int endTimestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'endTimestamp',
        value: [endTimestamp],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      endTimestampNotEqualTo(int endTimestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTimestamp',
              lower: [],
              upper: [endTimestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTimestamp',
              lower: [endTimestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTimestamp',
              lower: [endTimestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTimestamp',
              lower: [],
              upper: [endTimestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      endTimestampGreaterThan(
    int endTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTimestamp',
        lower: [endTimestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      endTimestampLessThan(
    int endTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTimestamp',
        lower: [],
        upper: [endTimestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterWhereClause>
      endTimestampBetween(
    int lowerEndTimestamp,
    int upperEndTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTimestamp',
        lower: [lowerEndTimestamp],
        includeLower: includeLower,
        upper: [upperEndTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoredChatTickerQueryFilter
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QFilterCondition> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'authorId',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'authorId',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      authorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authorId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      endTimestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      endTimestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      endTimestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      endTimestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      indexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      indexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tickerJsonString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tickerJsonString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tickerJsonString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tickerJsonString',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      tickerJsonStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tickerJsonString',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      timestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      timestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterFilterCondition>
      timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoredChatTickerQueryObject
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QFilterCondition> {}

extension StoredChatTickerQueryLinks
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QFilterCondition> {}

extension StoredChatTickerQuerySortBy
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QSortBy> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByAuthorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByAuthorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByEndTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByEndTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimestamp', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy> sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByTickerJsonString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tickerJsonString', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByTickerJsonStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tickerJsonString', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension StoredChatTickerQuerySortThenBy
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QSortThenBy> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByAuthorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByAuthorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByEndTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByEndTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimestamp', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy> thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByTickerJsonString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tickerJsonString', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByTickerJsonStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tickerJsonString', Sort.desc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension StoredChatTickerQueryWhereDistinct
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct> {
  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct>
      distinctByAuthorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct>
      distinctByEndTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTimestamp');
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct>
      distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct>
      distinctByTickerJsonString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tickerJsonString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatTicker, StoredChatTicker, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension StoredChatTickerQueryProperty
    on QueryBuilder<StoredChatTicker, StoredChatTicker, QQueryProperty> {
  QueryBuilder<StoredChatTicker, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StoredChatTicker, String?, QQueryOperations> authorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authorId');
    });
  }

  QueryBuilder<StoredChatTicker, int, QQueryOperations> endTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTimestamp');
    });
  }

  QueryBuilder<StoredChatTicker, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<StoredChatTicker, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<StoredChatTicker, String, QQueryOperations>
      tickerJsonStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tickerJsonString');
    });
  }

  QueryBuilder<StoredChatTicker, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
