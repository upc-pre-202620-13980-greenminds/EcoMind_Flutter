import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/quests/domain/quest_filters.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('general search excludes family quests and filters the title response locally', () async {
    final paths = <String>[];
    final repository = QuestRepository(sessionRepository: _SessionRepository());
    await http.runWithClient(
      () async {
        final all = await repository.search('agua');
        final activities = await repository.search(
          'agua',
          filters: const QuestFilters(types: {'ACTIVITIES'}),
        );
        final family = await repository.search(
          'agua',
          filters: const QuestFilters(types: {'FAMILY'}),
        );
        expect(activities.single.id, 1);
        expect(all.single.id, 1);
        expect(family, isEmpty);
        expect(paths, ['/api/v1/quests/search']);
      },
      () => MockClient((request) async {
        paths.add(request.url.path);
        return http.Response(
          '[{"id":1,"title":"Agua","description":"Revisa los caños",'
          '"theme":"CHECKBOX","type":"ACTIVITIES"},'
          '{"id":2,"title":"Agua en casa","description":"Revisen los caños",'
          '"theme":"CHECKBOX","type":"FAMILY"}]',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
  });
}

class _SessionRepository implements SessionRepository {
  @override
  Future<Session?> getSession() async => Session(
    accessToken: 'test',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
    accountId: 1,
  );

  @override
  Future<void> saveSession(Session session) async {}

  @override
  Future<void> clearSession() async {}
}
