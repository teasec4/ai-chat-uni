import 'package:chatgptclone/data/models/saved_message.dart';
import 'package:chatgptclone/data/models/saved_session.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late final Isar _isar;
  bool _initialized = false;

  Isar get isar => _isar;

  Future<void> initialize() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      SavedSessionSchema,
      SavedMessageSchema,
    ], directory: dir.path);
    _initialized = true;
  }

  // ── Sessions ────────────────────────────────────────────────

  Future<void> saveSessions(List<SavedSession> sessions) async {
    await _isar.writeTxn(() async {
      await _isar.savedSessions.putAll(sessions);
    });
  }

  Future<void> saveSession(SavedSession session) async {
    await _isar.writeTxn(() async {
      await _isar.savedSessions.put(session);
    });
  }

  Future<List<SavedSession>> loadAllSessions() async {
    return _isar.savedSessions.where().findAll();
  }

  // ── Messages ────────────────────────────────────────────────

  Future<void> saveMessages(
    String sessionId,
    List<SavedMessage> messages,
  ) async {
    await _isar.writeTxn(() async {
      final oldMessages = await _isar.savedMessages
          .filter()
          .sessionIdEqualTo(sessionId)
          .findAll();

      await _isar.savedMessages.deleteAll(
        oldMessages.map((m) => m.id).toList(),
      );

      await _isar.savedMessages.putAll(messages);
    });
  }

  Future<List<SavedMessage>> loadMessages(String sessionId) async {
    return _isar.savedMessages
        .filter()
        .sessionIdEqualTo(sessionId)
        .sortBySortOrder()
        .findAll();
  }

  // ── Cleanup ─────────────────────────────────────────────────

  Future<void> deleteSession(String sessionId) async {
    await _isar.writeTxn(() async {
      final messages = await _isar.savedMessages
          .filter()
          .sessionIdEqualTo(sessionId)
          .findAll();

      await _isar.savedMessages.deleteAll(messages.map((m) => m.id).toList());

      final session = await _isar.savedSessions
          .filter()
          .sessionIdEqualTo(sessionId)
          .findFirst();

      if (session != null) {
        await _isar.savedSessions.delete(session.id);
      }
    });
  }

  void dispose() {
    if (_initialized) {
      _isar.close();
      _initialized = false;
    }
  }
}
