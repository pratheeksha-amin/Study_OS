import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/subject_provider.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Subjects"),
      ),
      body: subjectsAsync.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No subjects added yet."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push(AppRoutes.addSubject),
                    child: const Text("Add First Subject"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                child: ListTile(
                  title: Text(subject.name),
                  subtitle: Text(
                    "Progress: ${subject.completedTopics}/${subject.totalTopics} • Priority: ${subject.priority}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Today"),
                      Switch(
                        value: subject.isSelectedForToday,
                        onChanged: (val) {
                          ref.read(subjectsProvider.notifier).toggleTodaySelection(subject.id!, val);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          ref.read(subjectsProvider.notifier).deleteSubject(subject.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addSubject),
        child: const Icon(Icons.add),
      ),
    );
  }
}
