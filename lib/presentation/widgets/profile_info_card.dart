import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final int _completedTasks;
  final int _incompletedTasks;

  const ProfileInfoCard({
    super.key,
    int completedTasks = 0,
    int incompletedTasks = 0,
  })  : _completedTasks = completedTasks,
        _incompletedTasks = incompletedTasks;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    maxHeight: 64,
                    maxWidth: 64,
                  ),
                  child: Image.asset('assets/image/ahsan.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ahsan Habib",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_incompletedTasks incompleted, $_completedTasks completed',
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
