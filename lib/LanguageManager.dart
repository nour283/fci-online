import 'package:flutter/material.dart';

class LanguageInfo {
  final String code;
  final String name;
  final String englishName;
  final bool isRTL;
  final String speechCode;
  final String flag;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.englishName,
    required this.isRTL,
    required this.speechCode,
    required this.flag,
  });
}

class LanguageManager {
  // Supported languages with their properties
  static const Map<String, LanguageInfo> supportedLanguages = {
    'ar': LanguageInfo(
      code: 'ar',
      name: 'العربية',
      englishName: 'Arabic',
      isRTL: true,
      speechCode: 'ar_SA',
      flag: '🇸🇦',
    ),
    'en': LanguageInfo(
      code: 'en',
      name: 'English',
      englishName: 'English',
      isRTL: false,
      speechCode: 'en_US',
      flag: '🇺🇸',
    ),
    'fr': LanguageInfo(
      code: 'fr',
      name: 'Français',
      englishName: 'French',
      isRTL: false,
      speechCode: 'fr_FR',
      flag: '🇫🇷',
    ),
    'es': LanguageInfo(
      code: 'es',
      name: 'Español',
      englishName: 'Spanish',
      isRTL: false,
      speechCode: 'es_ES',
      flag: '🇪🇸',
    ),
    'de': LanguageInfo(
      code: 'de',
      name: 'Deutsch',
      englishName: 'German',
      isRTL: false,
      speechCode: 'de_DE',
      flag: '🇩🇪',
    ),
    'ru': LanguageInfo(
      code: 'ru',
      name: 'Русский',
      englishName: 'Russian',
      isRTL: false,
      speechCode: 'ru_RU',
      flag: '🇷🇺',
    ),
    'zh': LanguageInfo(
      code: 'zh',
      name: '中文',
      englishName: 'Chinese',
      isRTL: false,
      speechCode: 'zh_CN',
      flag: '🇨🇳',
    ),
    'ja': LanguageInfo(
      code: 'ja',
      name: '日本語',
      englishName: 'Japanese',
      isRTL: false,
      speechCode: 'ja_JP',
      flag: '🇯🇵',
    ),
    'ko': LanguageInfo(
      code: 'ko',
      name: '한국어',
      englishName: 'Korean',
      isRTL: false,
      speechCode: 'ko_KR',
      flag: '🇰🇷',
    ),
    'it': LanguageInfo(
      code: 'it',
      name: 'Italiano',
      englishName: 'Italian',
      isRTL: false,
      speechCode: 'it_IT',
      flag: '🇮🇹',
    ),
    'pt': LanguageInfo(
      code: 'pt',
      name: 'Português',
      englishName: 'Portuguese',
      isRTL: false,
      speechCode: 'pt_BR',
      flag: '🇧🇷',
    ),
    'hi': LanguageInfo(
      code: 'hi',
      name: 'हिन्दी',
      englishName: 'Hindi',
      isRTL: false,
      speechCode: 'hi_IN',
      flag: '🇮🇳',
    ),
    'tr': LanguageInfo(
      code: 'tr',
      name: 'Türkçe',
      englishName: 'Turkish',
      isRTL: false,
      speechCode: 'tr_TR',
      flag: '🇹🇷',
    ),
    'nl': LanguageInfo(
      code: 'nl',
      name: 'Nederlands',
      englishName: 'Dutch',
      isRTL: false,
      speechCode: 'nl_NL',
      flag: '🇳🇱',
    ),
    'sv': LanguageInfo(
      code: 'sv',
      name: 'Svenska',
      englishName: 'Swedish',
      isRTL: false,
      speechCode: 'sv_SE',
      flag: '🇸🇪',
    ),
    'pl': LanguageInfo(
      code: 'pl',
      name: 'Polski',
      englishName: 'Polish',
      isRTL: false,
      speechCode: 'pl_PL',
      flag: '🇵🇱',
    ),
  };

  // Language detection patterns - using getter instead of const
  static Map<String, List<RegExp>> get languagePatterns => {
    'ar': [
      RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]'),
    ],
    'en': [
      RegExp(r'[a-zA-Z]'),
    ],
    'fr': [
      RegExp(r'[àâäçéèêëïîôöùûüÿ]', caseSensitive: false),
      RegExp(r'\b(le|la|les|un|une|des|du|de|et|ou|mais|donc|car|ni|or)\b', caseSensitive: false),
    ],
    'es': [
      RegExp(r'[áéíóúñü]', caseSensitive: false),
      RegExp(r'\b(el|la|los|las|un|una|y|o|pero|que|de|en|con|por|para)\b', caseSensitive: false),
    ],
    'de': [
      RegExp(r'[äöüß]', caseSensitive: false),
      RegExp(r'\b(der|die|das|ein|eine|und|oder|aber|dass|von|zu|mit|auf|für)\b', caseSensitive: false),
    ],
    'ru': [
      RegExp(r'[\u0400-\u04FF]'),
    ],
    'zh': [
      RegExp(r'[\u4E00-\u9FFF]'),
    ],
    'ja': [
      RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF]'),
    ],
    'ko': [
      RegExp(r'[\uAC00-\uD7AF\u1100-\u11FF\u3130-\u318F]'),
    ],
    'it': [
      RegExp(r'[àèéìíîòóù]', caseSensitive: false),
      RegExp(r'\b(il|la|lo|gli|le|un|una|e|o|ma|che|di|in|con|per|da)\b', caseSensitive: false),
    ],
    'pt': [
      RegExp(r'[àáâãçéêíóôõú]', caseSensitive: false),
      RegExp(r'\b(o|a|os|as|um|uma|e|ou|mas|que|de|em|com|por|para)\b', caseSensitive: false),
    ],
    'hi': [
      RegExp(r'[\u0900-\u097F]'),
    ],
    'tr': [
      RegExp(r'[çğıöşü]', caseSensitive: false),
      RegExp(r'\b(bir|bu|şu|o|ve|veya|ama|ki|de|da|ile|için|den|dan)\b', caseSensitive: false),
    ],
    'nl': [
      RegExp(r'[ëïöü]', caseSensitive: false),
      RegExp(r'\b(de|het|een|en|of|maar|dat|van|in|met|op|voor|aan)\b', caseSensitive: false),
    ],
    'sv': [
      RegExp(r'[åäö]', caseSensitive: false),
      RegExp(r'\b(en|ett|och|eller|men|att|av|i|med|på|för|till)\b', caseSensitive: false),
    ],
    'pl': [
      RegExp(r'[ąćęłńóśźż]', caseSensitive: false),
      RegExp(r'\b(i|lub|ale|że|w|na|z|do|od|przez|dla|o)\b', caseSensitive: false),
    ],
  };

  // Detect language based on text patterns
  static String detectLanguage(String text) {
    if (text.isEmpty) return 'en'; // Default to English

    Map<String, int> scores = {};

    // Initialize scores
    for (String lang in supportedLanguages.keys) {
      scores[lang] = 0;
    }

    // Score based on character patterns
    for (String lang in languagePatterns.keys) {
      List<RegExp> patterns = languagePatterns[lang]!;
      for (RegExp pattern in patterns) {
        Iterable<Match> matches = pattern.allMatches(text);
        scores[lang] = scores[lang]! + matches.length;
      }
    }

    // Find language with highest score
    String detectedLang = 'en';
    int maxScore = 0;

    scores.forEach((lang, score) {
      if (score > maxScore) {
        maxScore = score;
        detectedLang = lang;
      }
    });

    return detectedLang;
  }

  // Get language info by code
  static LanguageInfo? getLanguageInfo(String code) {
    return supportedLanguages[code];
  }

  // Get all supported languages as a list
  static List<LanguageInfo> getAllLanguages() {
    return supportedLanguages.values.toList();
  }

  // Check if language is supported
  static bool isLanguageSupported(String code) {
    return supportedLanguages.containsKey(code);
  }

  // Get language name in its native script
  static String getLanguageName(String code) {
    return supportedLanguages[code]?.name ?? 'Unknown';
  }

  // Get language name in English
  static String getLanguageEnglishName(String code) {
    return supportedLanguages[code]?.englishName ?? 'Unknown';
  }

  // Check if language is RTL
  static bool isRTL(String code) {
    return supportedLanguages[code]?.isRTL ?? false;
  }

  // Get speech code for TTS
  static String getSpeechCode(String code) {
    return supportedLanguages[code]?.speechCode ?? 'en_US';
  }

  // Get flag emoji
  static String getFlag(String code) {
    return supportedLanguages[code]?.flag ?? '🏳️';
  }

  // Get text direction based on language
  static TextDirection getTextDirection(String code) {
    return isRTL(code) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get locale from language code
  static Locale getLocale(String code) {
    return Locale(code);
  }
}