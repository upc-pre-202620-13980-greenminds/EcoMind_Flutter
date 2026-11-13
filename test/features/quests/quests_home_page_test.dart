import 'dart:async';

import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/theme.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quests_home_page.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_state.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_state.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profile = _Profile();

  Future<void> openHome(WidgetTester tester, _Quests quests) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    getIt.registerSingleton<ProfileViewModel>(profile);
    getIt.registerSingleton<NotificationsViewModel>(_Notifications());
    addTearDown(getIt.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es', '419'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: const MaterialTheme(ecoMindTextTheme).light(),
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData.fromView(tester.view)
                .copyWith(textScaler: const TextScaler.linear(1.5)),
            child: QuestsHomePage(profile: profile, repository: quests),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('greets the parent and resumes the saved assignment', (
    tester,
  ) async {
    final quests = _Quests(hasPending: true);
    await openHome(tester, quests);
    expect(find.text('Bienvenido de vuelta, Diego'), findsOneWidget);
    final heading = tester.widget<Text>(
      find.text('Continúa donde te quedaste'),
    );
    expect(heading.style!.fontWeight, FontWeight.w400);
    expect(find.text('5 min · Desde 8 años'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continuar reto'));
    await tester.pumpAndSettle();
    expect(quests.openedAssignmentId, 35);
    final activity = tester.widget<CheckboxListTile>(
      find.byType(CheckboxListTile),
    );
    expect(activity.value, isTrue);
  });

  testWidgets('omits the pending section and opens title search', (
    tester,
  ) async {
    final quests = _Quests(hasPending: false);
    await openHome(tester, quests);
    expect(find.text('Continúa donde te quedaste'), findsNothing);
    expect(find.text('Continuar reto'), findsNothing);

    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'agua');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(quests.searchedTitle, 'agua');
    expect(find.text(_Quests.recommended.title), findsOneWidget);
  });

  testWidgets('shows detail, activities and rewards in separate stages', (
    tester,
  ) async {
    final quests = _Quests(hasPending: false);
    await openHome(tester, quests);
    quests.loadingDetails = Completer<void>();
    await tester.tap(find.text(_Quests.recommended.title));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('RETO'), findsOneWidget);
    expect(find.text('agua'), findsOneWidget);
    expect(find.text(_Quests.recommended.description), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
    expect(quests.detailsLoads, 0);

    await tester.tap(find.text('Empezar reto'));
    await tester.pump();
    expect(quests.detailsLoads, 1);
    expect(quests.started, isFalse);
    quests.loadingDetails!.complete();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('¡Preparados, listos…\ncomenzó el reto!'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();
    expect(find.text('0 % completado'), findsOneWidget);
    quests.savingCheck = Completer<void>();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isTrue,
    );
    expect(find.text('0 % completado'), findsOneWidget);
    quests.savingCheck!.complete();
    await tester.pumpAndSettle();
    expect(find.text('100 % completado'), findsOneWidget);
    expect(quests.detailsLoads, 2);

    await tester.tap(find.text('Finalizar reto'));
    await tester.pumpAndSettle();
    expect(find.text('¡Reto completado!\n¡Buen trabajo!'), findsOneWidget);
    expect(find.text('+20 EcoPoints'), findsOneWidget);
    expect(find.text('+3 gemas'), findsOneWidget);
  });
}

class _Profile extends ChangeNotifier implements ProfileViewModel {
  @override
  final state = const ProfileState(
    profile: UserProfile(
      id: 1,
      name: 'Diego',
      socialRole: SocialRole.parent,
      streak: 0,
      lastStreakDate: null,
      ecopoints: 16,
      gemBalance: 360,
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Notifications extends ChangeNotifier implements NotificationsViewModel {
  @override
  final state = const NotificationsState();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Quests implements QuestRepository {
  _Quests({required this.hasPending});

  static const recommended = Quest(
    id: 2,
    title: 'Detecten fugas de agua',
    description: 'Revisen juntos los caños de casa.',
    theme: 'CHECKBOX',
    type: 'ACTIVITIES',
    minutes: 5,
    age: 8,
    category: 'WATER',
    ecopoints: 20,
    gems: 3,
  );
  static const _pending = (
    quest: Quest(
      id: 1,
      title: 'Ahorren energía en casa',
      description: 'Elijan dos hábitos para ahorrar electricidad.',
      theme: 'COLLABORATIVE',
      type: 'COLLABORATIVE',
    ),
    assignment: QuestAssignment(id: 35, questId: 1, status: 'IN_PROGRESS'),
  );

  final bool hasPending;
  int? openedAssignmentId;
  String? searchedTitle;
  bool started = false;
  bool checked = false;
  Completer<void>? savingCheck;
  Completer<void>? loadingDetails;
  int detailsLoads = 0;

  @override
  Future<List<Quest>> getCatalog() async => [recommended, _pending.quest];

  @override
  Future<PendingQuest?> getPending() async => hasPending ? _pending : null;

  @override
  Future<List<Quest>> search(String title) async {
    searchedTitle = title;
    return [recommended];
  }

  @override
  Future<QuestDetails> getDetails(Quest quest, {int? assignmentId}) async {
    detailsLoads++;
    await loadingDetails?.future;
    openedAssignmentId = assignmentId;
    if (quest == recommended) {
      return (
        assignment: !started
            ? null
            : QuestAssignment(
                id: 51,
                questId: quest.id,
                status: checked ? 'READY_TO_COMPLETE' : 'IN_PROGRESS',
                progress: checked ? 100 : 0,
              ),
        activities: [
          QuestActivity(
            description: 'Revisen los caños',
            type: 'CHECKBOX',
            assignmentId: started ? 71 : null,
            isComplete: checked,
            minCharacters: 1,
          ),
        ],
      );
    }
    return (
      assignment: _pending.assignment,
      activities: const [
        QuestActivity(
          description: 'Apaguen las luces',
          type: 'CHECKBOX',
          assignmentId: 72,
          isComplete: true,
          minCharacters: 1,
        ),
      ],
    );
  }

  @override
  Future<int> start(int questId) async {
    expect(questId, recommended.id);
    started = true;
    return 51;
  }

  @override
  Future<({QuestAssignment assignment, bool isComplete, String? response})>
  submit(int activityId, Map<String, Object> value) async {
    expect(activityId, 71);
    await savingCheck?.future;
    checked = value['checked'] == true;
    return (
      assignment: QuestAssignment(
        id: 51,
        questId: recommended.id,
        status: checked ? 'READY_TO_COMPLETE' : 'IN_PROGRESS',
        progress: checked ? 100 : 0,
      ),
      isComplete: checked,
      response: null,
    );
  }

  @override
  Future<void> finish(int assignmentId) async {
    expect(assignmentId, 51);
    expect(checked, isTrue);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
