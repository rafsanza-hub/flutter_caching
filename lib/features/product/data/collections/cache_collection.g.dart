// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCacheTimestampCollectionCollection on Isar {
  IsarCollection<CacheTimestampCollection> get cacheTimestampCollections =>
      this.collection();
}

const CacheTimestampCollectionSchema = CollectionSchema(
  name: r'CacheTimestampCollection',
  id: -3722073510913951444,
  properties: {
    r'cacheId': PropertySchema(
      id: 0,
      name: r'cacheId',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 1,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _cacheTimestampCollectionEstimateSize,
  serialize: _cacheTimestampCollectionSerialize,
  deserialize: _cacheTimestampCollectionDeserialize,
  deserializeProp: _cacheTimestampCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheId': IndexSchema(
      id: -7372113173438779531,
      name: r'cacheId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cacheId',
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
  getId: _cacheTimestampCollectionGetId,
  getLinks: _cacheTimestampCollectionGetLinks,
  attach: _cacheTimestampCollectionAttach,
  version: '3.1.0+1',
);

int _cacheTimestampCollectionEstimateSize(
  CacheTimestampCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _cacheTimestampCollectionSerialize(
  CacheTimestampCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cacheId);
  writer.writeDateTime(offsets[1], object.timestamp);
}

CacheTimestampCollection _cacheTimestampCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CacheTimestampCollection(
    cacheId: reader.readLongOrNull(offsets[0]),
    timestamp: reader.readDateTime(offsets[1]),
  );
  object.id = id;
  return object;
}

P _cacheTimestampCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cacheTimestampCollectionGetId(CacheTimestampCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cacheTimestampCollectionGetLinks(
    CacheTimestampCollection object) {
  return [];
}

void _cacheTimestampCollectionAttach(
    IsarCollection<dynamic> col, Id id, CacheTimestampCollection object) {
  object.id = id;
}

extension CacheTimestampCollectionByIndex
    on IsarCollection<CacheTimestampCollection> {
  Future<CacheTimestampCollection?> getByCacheId(int? cacheId) {
    return getByIndex(r'cacheId', [cacheId]);
  }

  CacheTimestampCollection? getByCacheIdSync(int? cacheId) {
    return getByIndexSync(r'cacheId', [cacheId]);
  }

  Future<bool> deleteByCacheId(int? cacheId) {
    return deleteByIndex(r'cacheId', [cacheId]);
  }

  bool deleteByCacheIdSync(int? cacheId) {
    return deleteByIndexSync(r'cacheId', [cacheId]);
  }

  Future<List<CacheTimestampCollection?>> getAllByCacheId(
      List<int?> cacheIdValues) {
    final values = cacheIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheId', values);
  }

  List<CacheTimestampCollection?> getAllByCacheIdSync(
      List<int?> cacheIdValues) {
    final values = cacheIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheId', values);
  }

  Future<int> deleteAllByCacheId(List<int?> cacheIdValues) {
    final values = cacheIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheId', values);
  }

  int deleteAllByCacheIdSync(List<int?> cacheIdValues) {
    final values = cacheIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheId', values);
  }

  Future<Id> putByCacheId(CacheTimestampCollection object) {
    return putByIndex(r'cacheId', object);
  }

  Id putByCacheIdSync(CacheTimestampCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheId(List<CacheTimestampCollection> objects) {
    return putAllByIndex(r'cacheId', objects);
  }

  List<Id> putAllByCacheIdSync(List<CacheTimestampCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheId', objects, saveLinks: saveLinks);
  }
}

extension CacheTimestampCollectionQueryWhereSort on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QWhere> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterWhere>
      anyCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheId'),
      );
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterWhere>
      anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension CacheTimestampCollectionQueryWhere on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QWhereClause> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheId',
        value: [null],
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdEqualTo(int? cacheId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheId',
        value: [cacheId],
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdNotEqualTo(int? cacheId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheId',
              lower: [],
              upper: [cacheId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheId',
              lower: [cacheId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheId',
              lower: [cacheId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheId',
              lower: [],
              upper: [cacheId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdGreaterThan(
    int? cacheId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheId',
        lower: [cacheId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdLessThan(
    int? cacheId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheId',
        lower: [],
        upper: [cacheId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> cacheIdBetween(
    int? lowerCacheId,
    int? upperCacheId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheId',
        lower: [lowerCacheId],
        includeLower: includeLower,
        upper: [upperCacheId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> timestampNotEqualTo(DateTime timestamp) {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> timestampGreaterThan(
    DateTime timestamp, {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
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

extension CacheTimestampCollectionQueryFilter on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QFilterCondition> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cacheId',
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cacheId',
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> cacheIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> timestampLessThan(
    DateTime value, {
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

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection,
      QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
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

extension CacheTimestampCollectionQueryObject on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QFilterCondition> {}

extension CacheTimestampCollectionQueryLinks on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QFilterCondition> {}

extension CacheTimestampCollectionQuerySortBy on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QSortBy> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      sortByCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.asc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      sortByCacheIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.desc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension CacheTimestampCollectionQuerySortThenBy on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QSortThenBy> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenByCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.asc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenByCacheIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.desc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension CacheTimestampCollectionQueryWhereDistinct on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QDistinct> {
  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QDistinct>
      distinctByCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheId');
    });
  }

  QueryBuilder<CacheTimestampCollection, CacheTimestampCollection, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension CacheTimestampCollectionQueryProperty on QueryBuilder<
    CacheTimestampCollection, CacheTimestampCollection, QQueryProperty> {
  QueryBuilder<CacheTimestampCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CacheTimestampCollection, int?, QQueryOperations>
      cacheIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheId');
    });
  }

  QueryBuilder<CacheTimestampCollection, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
