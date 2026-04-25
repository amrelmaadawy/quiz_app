import 'package:flutter/material.dart';

class AiGenerationButton extends StatefulWidget {
  final VoidCallback onGenerate;
  final bool isLoading;

  const AiGenerationButton({
    super.key,
    required this.onGenerate,
    this.isLoading = false,
  });

  @override
  State<AiGenerationButton> createState() => _AiGenerationButtonState();
}

class _AiGenerationButtonState extends State<AiGenerationButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'AI Question Generator',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Generate new design pattern questions using AI.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: widget.isLoading ? null : widget.onGenerate,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                widget.isLoading ? 'Generating...' : 'Generate Questions',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
