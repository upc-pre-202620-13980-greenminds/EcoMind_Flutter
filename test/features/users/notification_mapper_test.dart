import 'package:ecomind_parents/features/users/domain/notification_category.dart';
import 'package:ecomind_parents/features/users/domain/notification_type.dart';
import 'package:ecomind_parents/features/users/infrastructure/mappers/notification_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

// The inbox must keep working when the backend sends values this version does not know
void main() {
  Map<String, dynamic> row({
    int id = 1,
    String category = 'ACHIEVEMENTS_AND_BADGES',
    String type = 'ACHIEVEMENT_UNLOCKED',
    String createdAt = '2026-11-16T13:00:00Z',
  }) {
    return {
      'id': id,
      'category': category,
      'type': type,
      'title': 'Achievement unlocked',
      'message': 'You earned the achievement: First quest.',
      'read': false,
      'createdAt': createdAt,
    };
  }

  test('a known type keeps its type and category', () {
    final notifications = notificationsFromJson([row()]);

    expect(notifications.single.type, NotificationType.achievementUnlocked);
    expect(
      notifications.single.category,
      NotificationCategory.achievementsAndBadges,
    );
  });

  test('an unknown type is read as unknown', () {
    final notifications = notificationsFromJson([row(type: 'SOMETHING_NEW')]);

    expect(notifications.single.type, NotificationType.unknown);
  });

  test('an unknown category is read as unknown', () {
    final notifications = notificationsFromJson([
      row(category: 'SOMETHING_NEW'),
    ]);

    expect(notifications.single.category, NotificationCategory.unknown);
  });

  test('a row with a wrong date is left out and the rest is shown', () {
    final notifications = notificationsFromJson([
      row(id: 1),
      row(id: 2, createdAt: 'not a date'),
      row(id: 3, type: 'WEEKLY_SUMMARY'),
    ]);

    expect(notifications.map((n) => n.id), [1, 3]);
  });
}
