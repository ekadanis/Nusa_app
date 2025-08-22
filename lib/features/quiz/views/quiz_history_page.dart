import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../services/quiz_service.dart';
import '../widgets/game_history_item.dart';
import '../widgets/quiz_filter_section.dart';
import '../widgets/stats_summary.dart';
import '../widgets/quiz_empty_state.dart';
import '../../../widgets/back_button.dart';

@RoutePage()
class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  List<Map<String, dynamic>> allHistory = [];
  List<Map<String, dynamic>> filteredHistory = [];
  String selectedFilter = 'All';
  bool isLoading = true;

  final List<String> filterOptions = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month'
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  Future<void> _loadHistory() async {
    // Metode ini masih tersedia untuk kompatibilitas dengan RefreshIndicator
    // Data sebenarnya akan diambil melalui StreamBuilder
    
    // Force setState untuk re-trigger StreamBuilder
    setState(() {
      isLoading = true;
    });
    
    // Delay singkat untuk menunjukkan loading indicator
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }
  
  Stream<List<Map<String, dynamic>>> _getFilteredHistoryStream() {
    return QuizService.getQuizHistoryStream().map((history) {
      final now = DateTime.now();
      
      // Filter sesuai dengan selectedFilter
      switch (selectedFilter) {
        case 'Today':
          return history.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null && _isSameDay(date, now);
          }).toList();
          
        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          return history.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null && _isSameDay(date, yesterday);
          }).toList();
          
        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          return history.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null &&
                date.isAfter(weekStart.subtract(const Duration(days: 1)));
          }).toList();
          
        case 'This Month':
          return history.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null &&
                date.year == now.year &&
                date.month == now.month;
          }).toList();
          
        default:
          return history;
      }
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;

      final now = DateTime.now();

      switch (filter) {
        case 'Today':
          filteredHistory = allHistory.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null && _isSameDay(date, now);
          }).toList();
          break;

        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          filteredHistory = allHistory.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null && _isSameDay(date, yesterday);
          }).toList();
          break;

        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          filteredHistory = allHistory.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null &&
                date.isAfter(weekStart.subtract(const Duration(days: 1)));
          }).toList();
          break;

        case 'This Month':
          filteredHistory = allHistory.where((item) {
            final date = _parseDate(item['completedAt']);
            return date != null &&
                date.year == now.year &&
                date.month == now.month;
          }).toList();
          break;

        default:
          filteredHistory = allHistory;
      }
    });
  }

  DateTime? _parseDate(dynamic timestamp) {
    if (timestamp == null) return null;

    try {
      if (timestamp is String) {
        return DateTime.parse(timestamp);
      } else {
        // Firebase Timestamp
        return timestamp.toDate();
      }
    } catch (e) {
      return null;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: kToolbarHeight + 4.w,
        title: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              CustomBackButton(
                onPressed: () => context.router.maybePop(),
                backgroundColor: AppColors.grey10,
                iconColor: AppColors.grey90,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Quiz History',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey90,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          QuizFilterSection(
            filterOptions: filterOptions,
            selectedFilter: selectedFilter,
            onFilterSelected: _applyFilter,
          ),          // Stats Summary
          _buildStatsSummary(),// History List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary50,
                    ),
                  )
                : StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getFilteredHistoryStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting && filteredHistory.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary50,
                          ),
                        );
                      }
                      
                      // Gunakan data dari stream atau fallback ke filteredHistory yang sudah ada
                      final historyData = snapshot.hasData ? snapshot.data! : filteredHistory;
                      
                      if (historyData.isEmpty) {
                        return QuizEmptyState(
                          selectedFilter: selectedFilter,
                          onTakeQuizPressed: () {
                            context.router.maybePop();
                          },
                        );
                      }
                      
                      return RefreshIndicator(
                        onRefresh: _loadHistory,
                        color: AppColors.primary50,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          itemCount: historyData.length,
                          itemBuilder: (context, index) {
                            final item = historyData[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: GameHistoryItem(
                                category: QuizService.getCategoryNameById(
                                    item['categoryId']),
                                accuracy: ((item['accuracy'] ?? 0.0) as double)
                                    .round(),
                                xp: item['xpEarned'] ?? 0,
                                timeAgo: QuizService.formatTimeAgo(
                                    item['completedAt']),
                                color: QuizService.getCategoryColor(
                                    item['categoryId']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getFilteredHistoryStream(),
      builder: (context, snapshot) {
        final historyData = snapshot.data ?? filteredHistory;
        
        return StatsSummary(
          totalQuizzes: historyData.length,
          averageScore: _calculateAverageScore(historyData),
          totalXP: _calculateTotalXP(historyData),
        );
      },
    );
  }

  String _calculateAverageScore([List<Map<String, dynamic>>? history]) {
    final data = history ?? filteredHistory;
    if (data.isEmpty) return '0%';

    double totalAccuracy = 0;
    for (var item in data) {
      totalAccuracy += (item['accuracy'] ?? 0.0);
    }

    final average = totalAccuracy / data.length;
    return '${average.toStringAsFixed(0)}%';
  }

  int _calculateTotalXP([List<Map<String, dynamic>>? history]) {
    final data = history ?? filteredHistory;
    if (data.isEmpty) return 0;

    int total = 0;
    for (var item in data) {
      total += (item['xpEarned'] ?? 0) as int;
    }

    return total;
  }
}
