// ============================================================
// screens/home_screen.dart — Main Daily Checklist
//
// This is the heart of the app. It shows:
//   - Level bar with XP progress
//   - Daily encouraging message
//   - Today's task checklist
//   - Streak counter
//   - Daily summary section
//   - Bottom nav bar
// ============================================================

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../utils/xp_utils.dart';
import '../widgets/task_tile.dart';
import '../widgets/level_bar.dart';
import '../widgets/streak_badge.dart';
import '../widgets/add_task_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── State Variables ───────────────────────────────────────
  List<Task> _tasks = [];
  int _totalXP = 0;
  int _streak = 0;
  bool _isLoading = true;
  int _selectedNavIndex = 0; // 0=Home, 1=Rewards, 2=Settings

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── Load Data from Storage ────────────────────────────────
  Future<void> _loadData() async {
    final tasks    = await StorageService.loadTasks();
    final xp       = await StorageService.loadXP();
    final streak   = await StorageService.loadStreak();
    final lastDate = await StorageService.loadLastDate();
    final today    = _todayString();

    List<Task> todayTasks = tasks;

    // If it's a new day, reset completed status
    if (lastDate != today) {
      // Check if yesterday had any completions — update streak
      if (lastDate != null) {
        final yesterday = _yesterdayString();
        if (lastDate == yesterday) {
          // User was active yesterday — maintain or grow streak
          final hadCompletions = tasks.any((t) => t.isCompleted);
          if (hadCompletions) {
            await StorageService.saveStreak(streak + 1);
          }
        } else {
          // Missed a day — reset streak (but do it gently in UI)
          await StorageService.saveStreak(0);
        }
      }
      todayTasks = await StorageService.resetDailyTasks(tasks);
      await StorageService.saveLastDate(today);
    }

    setState(() {
      _tasks    = todayTasks;
      _totalXP  = xp;
      _streak   = streak;
      _isLoading = false;
    });
  }

  // ── Toggle Task Completion ─────────────────────────────────
  Future<void> _toggleTask(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final wasCompleted = task.isCompleted;

    // Update XP — add XP when completing, remove when un-checking
    final newXP = wasCompleted
        ? (_totalXP - task.xpValue).clamp(0, 999999)
        : _totalXP + task.xpValue;

    setState(() {
      _tasks[index] = task.copyWith(isCompleted: !wasCompleted);
      _totalXP = newXP;
    });

    // Save both to storage
    await StorageService.saveTasks(_tasks);
    await StorageService.saveXP(newXP);
  }

  // ── Add Custom Task ────────────────────────────────────────
  Future<void> _addCustomTask(String label, String emoji) async {
    final newTask = Task(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      emoji: emoji,
      xpValue: 10,
      isDefault: false,
    );

    setState(() {
      _tasks.add(newTask);
    });

    await StorageService.saveTasks(_tasks);
  }

  // ── Delete Custom Task ─────────────────────────────────────
  Future<void> _deleteTask(String taskId) async {
    setState(() {
      _tasks.removeWhere((t) => t.id == taskId);
    });
    await StorageService.saveTasks(_tasks);
  }

  // ── Open Add Task Bottom Sheet ─────────────────────────────
  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(onAdd: _addCustomTask),
    );
  }

  // ── Helper: Today's Date String ───────────────────────────
  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  String _yesterdayString() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month}-${yesterday.day}';
  }

  // ── Computed Getters ──────────────────────────────────────
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _totalXPToday   => _tasks
      .where((t) => t.isCompleted)
      .fold(0, (sum, t) => sum + t.xpValue);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final level        = XpUtils.getLevel(_totalXP);
    final levelName    = XpUtils.getLevelName(_totalXP);
    final progress     = XpUtils.getLevelProgress(_totalXP);
    final dailyMessage = XpUtils.getDailyMessage(_completedCount, _tasks.length);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),

      // ── App Bar ────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        title: const Text(
          'Level Up ⚔️',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF3D3060),
          ),
        ),
        actions: [
          // Streak badge in the top right
          StreakBadge(streak: _streak),
          const SizedBox(width: 12),
        ],
      ),

      // ── Main Scrollable Body ───────────────────────────────
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Level Bar Section ────────────────────────
              LevelBar(
                level: level,
                levelName: levelName,
                progress: progress,
                totalXP: _totalXP,
              ),

              const SizedBox(height: 20),

              // ── Daily Message Card ────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  dailyMessage,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5A4880),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // ── Today's Tasks Header ───────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    '$_completedCount / ${_tasks.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Task List ─────────────────────────────────
              // Builds a TaskTile for each task in the list
              ..._tasks.map((task) => TaskTile(
                task: task,
                onToggle: () => _toggleTask(task.id),
                onDelete: task.isDefault ? null : () => _deleteTask(task.id),
              )),

              const SizedBox(height: 12),

              // ── Add Task Button ───────────────────────────
              InkWell(
                onTap: _openAddTaskSheet,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF7C6EAF).withOpacity(0.4),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Color(0xFF7C6EAF), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Add your own task',
                        style: TextStyle(
                          color: const Color(0xFF7C6EAF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Daily Summary Section ─────────────────────
              _buildDailySummary(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ──────────────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEDE8F5),
        onDestinationSelected: (index) {
          setState(() => _selectedNavIndex = index);
          if (index == 1) Navigator.pushNamed(context, '/rewards');
          if (index == 2) Navigator.pushNamed(context, '/settings');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),   selectedIcon: Icon(Icons.home),   label: 'Home'),
          NavigationDestination(icon: Icon(Icons.star_outline),    selectedIcon: Icon(Icons.star),   label: 'Rewards'),
          NavigationDestination(icon: Icon(Icons.settings_outlined),selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // ── Daily Summary Widget ──────────────────────────────────
  Widget _buildDailySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today at a Glance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // XP Earned Today
            _summaryCard('⚡ XP Today', '+$_totalXPToday'),
            const SizedBox(width: 12),
            // Tasks Completed
            _summaryCard('✅ Done', '$_completedCount tasks'),
            const SizedBox(width: 12),
            // Current Streak
            _summaryCard('🔥 Streak', '$_streak days'),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3060),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
