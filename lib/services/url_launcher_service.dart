import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Сервис для открытия внешних ссылок и email
class UrlLauncherService {
  static const MethodChannel _channel = MethodChannel('hydracoach.url_launcher');

  /// Константы ссылок приложения
  static const String privacyPolicyUrl = 'https://www.playcus.com/privacy-policy';
  static const String websiteUrl = 'https://www.playcus.com';
  static const String supportEmail = 'support@playcus.com';
  static const String companyAddress = 'Thiseos 9, Flat/Office C1, Aglantzia, P.C. 2121, Nicosia, Cyprus';
  static const String dataSafetyGPUrl = 'https://docs.google.com/spreadsheets/d/1kPc5mX9z9Nm_7YDGTK1qkH-ZoQRdbXxQ00ICc6n2ipk/edit#gid=15532220';
  static const String dataSafetyIOSUrl = 'https://docs.google.com/spreadsheets/u/0/d/17QaT_AMP7UhtfrVNuZuznlrAyZvMDXlOpToA6-4Cpxg/htmlview#gid=1742509917';

  /// Открыть веб-ссылку
  static Future<bool> openUrl(String url) async {
    try {
      if (kDebugMode) {
        print('🔗 Открываем ссылку: $url');
      }

      // Для Windows/Desktop - копируем в буфер обмена и показываем сообщение
      await Clipboard.setData(ClipboardData(text: url));

      if (kDebugMode) {
        print('📋 Ссылка скопирована в буфер обмена: $url');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка открытия ссылки: $e');
      }
      return false;
    }
  }

  /// Открыть email клиент
  static Future<bool> openEmail(String email, {String? subject}) async {
    final emailUrl = 'mailto:$email${subject != null ? '?subject=${Uri.encodeComponent(subject)}' : ''}';
    return await openUrl(emailUrl);
  }

  /// Быстрые методы для основных ссылок приложения
  static Future<bool> openPrivacyPolicy() => openUrl(privacyPolicyUrl);
  static Future<bool> openWebsite() => openUrl(websiteUrl);
  static Future<bool> openSupportEmail() => openEmail(supportEmail, subject: 'HydraCoach Support');
  static Future<bool> openDataSafetyGP() => openUrl(dataSafetyGPUrl);
  static Future<bool> openDataSafetyIOS() => openUrl(dataSafetyIOSUrl);
}