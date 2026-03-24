import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/reward_model.dart';
import '../services/storage_service.dart';
import '../utils/xp_utils.dart';

class RewardsPresenter extends ChangeNotifier {
  int _totalXp = 0;
  bool _initialized = false;
  bool _initializing = false;
  Set<String> _knownUnlockedIds = <String>{};
  Set<String> _newlyUnlockedIds = <String>{};

  UnmodifiableListView<RewardItem> get rewards =>
      UnmodifiableListView(defaultRewards);
  int get totalXp => _totalXp;
  String get levelName => XpUtils.getLevelName(_totalXp);
  String get encouragement =>
      'Each little bit of progress can uncover something new.';

  Future<void> initialize() async {
    if (_initialized || _initializing) {
      return;
    }

    _initializing = true;
    try {
      _knownUnlockedIds =
          (await StorageService.loadUnlockedRewards()).toSet();

      if (_knownUnlockedIds.isEmpty) {
        _knownUnlockedIds = rewards
            .where((reward) => reward.xpNeeded <= _totalXp)
            .map((reward) => reward.id)
            .toSet();
        await StorageService.saveUnlockedRewards(_knownUnlockedIds.toList());
      }

      _initialized = true;
      notifyListeners();
    } finally {
      _initializing = false;
    }
  }

  bool isUnlocked(RewardItem reward) => _totalXp >= reward.xpNeeded;

  bool isNewlyUnlocked(RewardItem reward) =>
      _newlyUnlockedIds.contains(reward.id);

  Future<void> updateTotalXp(int value) async {
    _totalXp = value;

    if (!_initialized) {
      await initialize();
    }

    final unlockedNow = rewards
        .where((reward) => value >= reward.xpNeeded)
        .map((reward) => reward.id)
        .toSet();
    final freshUnlocks = unlockedNow.difference(_knownUnlockedIds);

    if (freshUnlocks.isNotEmpty) {
      _knownUnlockedIds = {..._knownUnlockedIds, ...freshUnlocks};
      _newlyUnlockedIds = {..._newlyUnlockedIds, ...freshUnlocks};
      await StorageService.saveUnlockedRewards(_knownUnlockedIds.toList());
    }

    notifyListeners();
  }
}
