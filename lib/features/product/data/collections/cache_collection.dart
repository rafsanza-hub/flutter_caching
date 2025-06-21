import 'package:isar/isar.dart';

part 'cache_collection.g.dart';

@collection
class CacheTimestampCollection {
  Id id = Isar.autoIncrement; 
  @Index(unique: true) 
  int?
      cacheId; 
  @Index()
  DateTime timestamp; 

  CacheTimestampCollection({this.cacheId, required this.timestamp});
}
