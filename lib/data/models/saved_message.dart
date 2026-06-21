import 'package:isar_community/isar.dart';

part 'saved_message.g.dart';

@collection
class SavedMessage {
  Id id = Isar.autoIncrement;

  @Index()
  late String sessionId;

  late String role;

  late String text;

  late int sortOrder;
}
