import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import '../services/units_service.dart';
import '../services/consent_service.dart';
import '../services/url_launcher_service.dart';
import '../services/locale_service.dart';
import '../widgets/language_selector_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer2<HydrationProvider, UnitsService>(
          builder: (context, hydrationProvider, unitsService, child) {
            final displayWeight = unitsService.formatWeight(
              hydrationProvider.weight,
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      l10n.settingsTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 350.ms),
                  ),

                  // DEBUG PANELS
                  if (kDebugMode) _buildUsercentricsDebugPanel(),

                  // Profile Section
                  _buildSectionTitle(l10n.profileSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          l10n.weight,
                          displayWeight,
                          Icons.monitor_weight_outlined,
                          () => _showWeightDialog(
                            hydrationProvider,
                            unitsService,
                            l10n,
                          ),
                        ),
                        _buildDivider(),
                        _buildProfileTile(
                          l10n.dietMode,
                          _getDietModeText(hydrationProvider.dietMode, l10n),
                          Icons.restaurant_menu,
                          () => _showDietDialog(hydrationProvider, l10n),
                        ),
                        _buildDivider(),
                        _buildProfileTile(
                          l10n.activityLevel,
                          _getActivityText(
                            hydrationProvider.activityLevel,
                            l10n,
                          ),
                          Icons.fitness_center,
                          () => _showActivityDialog(hydrationProvider, l10n),
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(
                            Icons.straighten,
                            color: Colors.blue,
                          ),
                          title: Text(l10n.unitsSection),
                          subtitle: Text(
                            unitsService.isMetric
                                ? l10n.metricSystem
                                : l10n.imperialSystem,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unitsService.isMetric
                                  ? l10n.metricUnits
                                  : l10n.imperialUnits,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),

                  // Language Section
                  _buildSectionTitle(l10n.languageSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Consumer<LocaleService>(
                      builder: (context, localeService, _) {
                        final currentLocale = localeService
                            .getCurrentLocaleInfo();

                        return ListTile(
                          leading: const Icon(
                            Icons.language,
                            color: Colors.blue,
                          ),
                          title: Text(l10n.languageSettings),
                          subtitle: Row(
                            children: [
                              Text(
                                currentLocale.flag,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentLocale.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              LanguageSelectorBottomSheet.show(context),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  // About Section
                  _buildSectionTitle(l10n.aboutSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          l10n.version,
                          '2.0.8',
                          Icons.info_outline,
                          null,
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.rateApp,
                          '',
                          Icons.star_outline,
                          () async {
                            final success =
                                await UrlLauncherService.openAppStore();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? l10n.appStoreOpened
                                        : l10n.linkCopiedToClipboard,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.share,
                          '',
                          Icons.share_outlined,
                          () async {
                            final success = await UrlLauncherService.shareApp();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? l10n.shareDialogOpened
                                        : l10n.linkForSharingCopied,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.companyWebsite,
                          'playcus.com',
                          Icons.language_outlined,
                          () async {
                            final success =
                                await UrlLauncherService.openWebsite();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? l10n.websiteOpenedInBrowser
                                        : l10n.linkCopiedToClipboard,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _buildListTile(
                          l10n.support,
                          'support@playcus.com',
                          Icons.support_agent_outlined,
                          () async {
                            final success =
                                await UrlLauncherService.openSupportEmail();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? l10n.emailClientOpened
                                        : l10n.emailCopiedToClipboard,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        _buildListTile(
                          l10n.privacyPolicy,
                          'playcus.com/privacy-policy',
                          Icons.privacy_tip_outlined,
                          () async {
                            final success =
                                await UrlLauncherService.openPrivacyPolicy();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? l10n.privacyPolicyOpened
                                        : l10n.linkCopiedToClipboard,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  // Company Information
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Playcus Ltd',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thiseos 9, Flat/Office C1\nAglantzia, P.C. 2121\nNicosia, Cyprus',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'support@playcus.com',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap, {
    bool isPro = false,
  }) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;

        return ListTile(
          leading: Icon(icon, color: hasAccess ? Colors.blue : Colors.grey),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: hasAccess ? null : Colors.grey.shade600,
                  ),
                ),
              ),
              if (isPro && !subscriptionProvider.isPro) ...[
                const SizedBox(width: 8),
                Icon(Icons.star, size: 16, color: Colors.grey.shade400),
              ],
            ],
          ),
          subtitle: subtitle.isNotEmpty
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: hasAccess ? null : Colors.grey.shade400,
                  ),
                )
              : null,
          trailing: onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: hasAccess ? null : Colors.grey.shade300,
                )
              : null,
          onTap: onTap,
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }

  String _getDietModeText(String mode, AppLocalizations l10n) {
    switch (mode) {
      case 'normal':
        return l10n.dietModeNormal;
      case 'keto':
        return l10n.dietModeKeto;
      case 'fasting':
        return l10n.dietModeFasting;
      default:
        return mode;
    }
  }

  String _getActivityText(String level, AppLocalizations l10n) {
    switch (level) {
      case 'low':
        return l10n.activityLow;
      case 'medium':
        return l10n.activityMedium;
      case 'high':
        return l10n.activityHigh;
      default:
        return level;
    }
  }

  // Dialog Methods
  void _showWeightDialog(
    HydrationProvider provider,
    UnitsService units,
    AppLocalizations l10n,
  ) {
    double tempWeight = provider.weight;
    double displayWeight = units.toDisplayWeight(tempWeight);
    final weightUnit = units.weightUnit;
    final minWeight = units.isImperial ? 88.0 : 40.0;
    final maxWeight = units.isImperial ? 330.0 : 150.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.changeWeight),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${displayWeight.round()} $weightUnit',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Slider(
                value: displayWeight,
                min: minWeight,
                max: maxWeight,
                divisions: (maxWeight - minWeight).round(),
                onChanged: (value) {
                  setDialogState(() {
                    displayWeight = value;
                    tempWeight = units.toKilograms(value);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${minWeight.round()} $weightUnit',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  Text(
                    '${maxWeight.round()} $weightUnit',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                provider.updateProfile(
                  weight: tempWeight,
                  dietMode: provider.dietMode,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showDietDialog(HydrationProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dietMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.dietModeNormal),
              value: 'normal',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.dietModeKeto),
              value: 'keto',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.dietModeFasting),
              value: 'fasting',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showActivityDialog(HydrationProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.activityLevel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.activityLow),
              subtitle: Text(l10n.activityLowDesc),
              value: 'low',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.activityMedium),
              subtitle: Text(l10n.activityMediumDesc),
              value: 'medium',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.activityHigh),
              subtitle: Text(l10n.activityHighDesc),
              value: 'high',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Usercentrics Debug Panel
  Widget _buildUsercentricsDebugPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: Colors.orange.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                '🧪 Usercentrics Debug',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final consentService = ConsentService();
                      await consentService.forceShowConsentBanner(context);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Force Show Banner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final consentService = ConsentService();
                      await consentService.resetConsent();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Consent reset! Restart app to test.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset Consent'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () async {
              try {
                final consentService = ConsentService();
                await consentService.showPrivacySettings(context);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Privacy Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Settings ID: UxKlz-EOgB16Ne\nTemplate IDs: AppsFlyer, Firebase, AppLovin, Google Ads',
            style: TextStyle(
              fontSize: 10,
              color: Colors.orange.shade600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
