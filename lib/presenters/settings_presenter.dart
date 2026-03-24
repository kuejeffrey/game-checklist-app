import 'package:flutter/material.dart';

import '../services/affirmation_notification_service.dart';
import '../services/storage_service.dart';

class SettingsPresenter extends ChangeNotifier {
  SettingsPresenter({
    required this.versionLabel,
    required AffirmationNotificationService notificationService,
  }) : _notificationService = notificationService;

  final String versionLabel;
  final AffirmationNotificationService _notificationService;

  bool _isLoading = true;
  bool _affirmationsEnabled = false;
  TimeOfDay _affirmationTime = const TimeOfDay(hour: 9, minute: 0);

  bool get isLoading => _isLoading;
  bool get affirmationsEnabled => _affirmationsEnabled;
  TimeOfDay get affirmationTime => _affirmationTime;

  String get formattedAffirmationTime {
    final hour = _affirmationTime.hourOfPeriod == 0
        ? 12
        : _affirmationTime.hourOfPeriod;
    final minute = _affirmationTime.minute.toString().padLeft(2, '0');
    final suffix = _affirmationTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _notificationService.initialize();
    _affirmationsEnabled = await StorageService.loadAffirmationsEnabled();
    final savedTime = await StorageService.loadAffirmationTime();
    _affirmationTime = TimeOfDay(
      hour: savedTime['hour'] ?? 9,
      minute: savedTime['minute'] ?? 0,
    );

    if (_affirmationsEnabled) {
      await _notificationService.scheduleDailyAffirmation(_affirmationTime);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setAffirmationsEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        _affirmationsEnabled = false;
        await StorageService.saveAffirmationsEnabled(false);
        notifyListeners();
        return;
      }

      await _notificationService.scheduleDailyAffirmation(_affirmationTime);
    } else {
      await _notificationService.cancelDailyAffirmation();
    }

    _affirmationsEnabled = enabled;
    await StorageService.saveAffirmationsEnabled(enabled);
    notifyListeners();
  }

  Future<void> setAffirmationTime(TimeOfDay time) async {
    _affirmationTime = time;
    await StorageService.saveAffirmationTime(
      hour: time.hour,
      minute: time.minute,
    );

    if (_affirmationsEnabled) {
      await _notificationService.scheduleDailyAffirmation(_affirmationTime);
    }

    notifyListeners();
  }

  Future<void> resetAfterDataClear() async {
    _affirmationsEnabled = false;
    _affirmationTime = const TimeOfDay(hour: 9, minute: 0);
    await _notificationService.cancelDailyAffirmation();
    notifyListeners();
  }
}
