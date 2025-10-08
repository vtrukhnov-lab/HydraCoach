import 'package:flutter/material.dart';
import '../services/locale_service.dart';
import '../utils/app_helpers.dart';
import '../l10n/app_localizations.dart';

class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet({super.key});

  /// Show the language selector bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageSelectorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentCode = LocaleService.instance.currentCode;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header with drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 1),

            // Language list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: LocaleService.supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = LocaleService.supportedLocales[index];
                  final isCurrent = locale.code == currentCode;

                  return ListTile(
                    leading: Text(
                      locale.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(
                      locale.name,
                      style: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isCurrent
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    selected: isCurrent,
                    selectedTileColor: Colors.blue.withValues(alpha: 0.1),
                    onTap: isCurrent
                        ? null // Don't allow tapping current language
                        : () => _changeLanguage(context, locale.code),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Change language and restart app
  Future<void> _changeLanguage(BuildContext context, String code) async {
    // Close bottom sheet
    Navigator.pop(context);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Change locale (this will update NotificationService automatically)
      await LocaleService.instance.setLocale(code);

      // Close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Restart app
      await AppHelpers.restartApp();
    } catch (e) {
      // Close loading indicator
      if (context.mounted) {
        Navigator.pop(context);

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing language: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
