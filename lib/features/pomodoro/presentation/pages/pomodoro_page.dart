import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/subjects/presentation/providers/subject_provider.dart';
import '../providers/pomodoro_provider.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(pomodoroProvider);
    final selectedSubjects = ref.watch(selectedSubjectsProvider);
    
    final minutes = (timerState.timeLeft / 60).floor();
    final seconds = timerState.timeLeft % 60;

    return Scaffold(
      appBar: AppBar(title: const Text("Focus Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timerState.status == PomodoroStatus.studying 
                ? "Study Session" 
                : timerState.status == PomodoroStatus.idle 
                  ? "Ready to focus?" 
                  : "Break Time",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: timerState.timeLeft / (timerState.status == PomodoroStatus.studying ? 25*60 : 5*60),
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                Text(
                  "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 60),
            if (timerState.status == PomodoroStatus.idle)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Choose a subject to study",
                    border: OutlineInputBorder(),
                  ),
                  items: selectedSubjects.map((s) {
                    return DropdownMenuItem(value: s.id, child: Text(s.name));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(pomodoroProvider.notifier).startStudy(val);
                    }
                  },
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => ref.read(pomodoroProvider.notifier).reset(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red),
                    child: const Text("STOP"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
