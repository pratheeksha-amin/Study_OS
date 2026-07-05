import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../features/subjects/presentation/providers/subject_provider.dart';
import '../providers/plan_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPlan = ref.watch(dailyPlanProvider);
    // ignore: unused_local_variable
    final subjectsAsync = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("FocusFlow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(dailyPlan),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Study Plan",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.subjects),
                  child: const Text("Manage Subjects"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (dailyPlan.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "No subjects selected for today.\nGo to Manage Subjects to select some!",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyPlan.length,
                itemBuilder: (context, index) {
                  final plan = dailyPlan[index];
                  return Card(
                    child: ListTile(
                      title: Text(plan.subject.name),
                      subtitle: Text("Target: ${plan.targetTopics} topics • ${plan.estimatedMinutes} mins"),
                      trailing: IconButton(
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: () {
                          context.push(AppRoutes.pomodoro);
                        },
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            _buildQuickActions(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.analytics),
        label: const Text("Analytics"),
        icon: const Icon(Icons.bar_chart),
      ),
    );
  }

  Widget _buildSummaryCard(List<dynamic> plan) {
    final totalMins = plan.fold<int>(0, (sum, item) => sum + (item.estimatedMinutes as int));
    final totalTopics = plan.fold<int>(0, (sum, item) => sum + (item.targetTopics as int));

    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Today's Goal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("${totalTopics}", "Topics"),
                _buildStatItem("${(totalMins / 60).toStringAsFixed(1)}h", "Study Time"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: [
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text("Add Subject"),
              onPressed: () => context.push(AppRoutes.addSubject),
            ),
            ActionChip(
              avatar: const Icon(Icons.timer, size: 18),
              label: const Text("Pomodoro"),
              onPressed: () => context.push(AppRoutes.pomodoro),
            ),
            ActionChip(
              avatar: const Icon(Icons.list, size: 18),
              label: const Text("All Subjects"),
              onPressed: () => context.push(AppRoutes.subjects),
            ),
          ],
        ),
      ],
    );
  }
}
