import 'package:isar_community/isar.dart';

part 'saved_session.g.dart';

@collection
class SavedSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sessionId;

  late String title;

  late String preview;

  late String sectionLabel;

  late String updatedLabel;

  late int messageCount;

  String? createdAt;

  String? updatedAt;
}
