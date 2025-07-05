class LanguageDetector {
  /// كشف اللغة من النص
  static String detectLanguage(String text) {
    if (text.isEmpty) return 'en';

    // تنظيف النص من الأرقام والرموز
    String cleanText = text.replaceAll(RegExp(r'[0-9\s\p{P}]', unicode: true), '');

    if (cleanText.isEmpty) return 'en';

    // عدد الأحرف العربية
    int arabicChars = 0;
    // عدد الأحرف الإنجليزية
    int englishChars = 0;
    // عدد الأحرف الأخرى
    int otherChars = 0;

    for (int i = 0; i < cleanText.length; i++) {
      int charCode = cleanText.codeUnitAt(i);

      if (_isArabicChar(charCode)) {
        arabicChars++;
      } else if (_isEnglishChar(charCode)) {
        englishChars++;
      } else {
        otherChars++;
      }
    }

    // حساب النسب
    int totalChars = arabicChars + englishChars + otherChars;
    if (totalChars == 0) return 'en';

    double arabicRatio = arabicChars / totalChars;
    double englishRatio = englishChars / totalChars;

    // إذا كانت نسبة الأحرف العربية أكبر من 30%
    if (arabicRatio > 0.3) {
      return 'ar';
    }
    // إذا كانت نسبة الأحرف الإنجليزية أكبر من 50%
    else if (englishRatio > 0.5) {
      return 'en';
    }
    // إذا كان هناك أحرف عربية أكثر من الإنجليزية
    else if (arabicChars > englishChars) {
      return 'ar';
    }
    // الافتراضي هو الإنجليزية
    else {
      return 'en';
    }
  }

  /// التحقق من كون الحرف عربي
  static bool _isArabicChar(int charCode) {
    return (charCode >= 0x0600 && charCode <= 0x06FF) || // Arabic
        (charCode >= 0x0750 && charCode <= 0x077F) || // Arabic Supplement
        (charCode >= 0x08A0 && charCode <= 0x08FF) || // Arabic Extended-A
        (charCode >= 0xFB50 && charCode <= 0xFDFF) || // Arabic Presentation Forms-A
        (charCode >= 0xFE70 && charCode <= 0xFEFF);   // Arabic Presentation Forms-B
  }

  /// التحقق من كون الحرف إنجليزي
  static bool _isEnglishChar(int charCode) {
    return (charCode >= 0x0041 && charCode <= 0x005A) || // A-Z
        (charCode >= 0x0061 && charCode <= 0x007A);   // a-z
  }

  /// كشف اللغة مع تفاصيل إضافية
  static LanguageDetectionResult detectLanguageDetailed(String text) {
    if (text.isEmpty) {
      return LanguageDetectionResult(
        language: 'en',
        confidence: 0.0,
        arabicChars: 0,
        englishChars: 0,
        otherChars: 0,
      );
    }

    String cleanText = text.replaceAll(RegExp(r'[0-9\s\p{P}]', unicode: true), '');

    if (cleanText.isEmpty) {
      return LanguageDetectionResult(
        language: 'en',
        confidence: 0.0,
        arabicChars: 0,
        englishChars: 0,
        otherChars: 0,
      );
    }

    int arabicChars = 0;
    int englishChars = 0;
    int otherChars = 0;

    for (int i = 0; i < cleanText.length; i++) {
      int charCode = cleanText.codeUnitAt(i);

      if (_isArabicChar(charCode)) {
        arabicChars++;
      } else if (_isEnglishChar(charCode)) {
        englishChars++;
      } else {
        otherChars++;
      }
    }

    int totalChars = arabicChars + englishChars + otherChars;
    double arabicRatio = arabicChars / totalChars;
    double englishRatio = englishChars / totalChars;

    String detectedLanguage;
    double confidence;

    if (arabicRatio > 0.3) {
      detectedLanguage = 'ar';
      confidence = arabicRatio;
    } else if (englishRatio > 0.5) {
      detectedLanguage = 'en';
      confidence = englishRatio;
    } else if (arabicChars > englishChars) {
      detectedLanguage = 'ar';
      confidence = arabicRatio;
    } else {
      detectedLanguage = 'en';
      confidence = englishRatio;
    }

    return LanguageDetectionResult(
      language: detectedLanguage,
      confidence: confidence,
      arabicChars: arabicChars,
      englishChars: englishChars,
      otherChars: otherChars,
    );
  }

  /// قائمة بالكلمات المفتاحية العربية الشائعة
  static const List<String> _arabicKeywords = [
    'في', 'من', 'إلى', 'على', 'عن', 'مع', 'هذا', 'هذه', 'التي', 'الذي',
    'كان', 'كانت', 'يكون', 'تكون', 'هو', 'هي', 'أن', 'أنا', 'أنت',
    'نحن', 'أنتم', 'هم', 'هن', 'ما', 'كيف', 'متى', 'أين', 'لماذا',
    'والله', 'إن شاء الله', 'الحمد لله', 'سبحان الله', 'أستغفر الله'
  ];

  /// قائمة بالكلمات المفتاحية الإنجليزية الشائعة
  static const List<String> _englishKeywords = [
    'the', 'and', 'is', 'in', 'to', 'of', 'a', 'that', 'it', 'with',
    'for', 'as', 'was', 'on', 'are', 'you', 'this', 'be', 'at', 'by',
    'not', 'or', 'have', 'from', 'they', 'we', 'say', 'her', 'she', 'he',
    'hello', 'how', 'what', 'when', 'where', 'why', 'can', 'could', 'would'
  ];

  /// كشف اللغة باستخدام الكلمات المفتاحية
  static String detectLanguageByKeywords(String text) {
    String lowerText = text.toLowerCase();

    int arabicKeywordCount = 0;
    int englishKeywordCount = 0;

    for (String keyword in _arabicKeywords) {
      if (lowerText.contains(keyword)) {
        arabicKeywordCount++;
      }
    }

    for (String keyword in _englishKeywords) {
      if (lowerText.contains(keyword)) {
        englishKeywordCount++;
      }
    }

    if (arabicKeywordCount > englishKeywordCount) {
      return 'ar';
    } else if (englishKeywordCount > arabicKeywordCount) {
      return 'en';
    } else {
      // العودة إلى الكشف بالأحرف
      return detectLanguage(text);
    }
  }

  /// كشف اللغة المحسن (يجمع بين الطرق المختلفة)
  static String detectLanguageEnhanced(String text) {
    // كشف بالأحرف
    String charBasedResult = detectLanguage(text);

    // كشف بالكلمات المفتاحية
    String keywordBasedResult = detectLanguageByKeywords(text);

    // إذا كانت النتائج متطابقة
    if (charBasedResult == keywordBasedResult) {
      return charBasedResult;
    }

    // إذا كانت مختلفة، نأخذ النتيجة الأكثر دقة
    LanguageDetectionResult detailedResult = detectLanguageDetailed(text);

    // إذا كانت الثقة عالية، نأخذ النتيجة
    if (detailedResult.confidence > 0.7) {
      return detailedResult.language;
    }

    // وإلا نأخذ نتيجة الكلمات المفتاحية
    return keywordBasedResult;
  }
}

/// نتيجة كشف اللغة مع تفاصيل
class LanguageDetectionResult {
  final String language;
  final double confidence;
  final int arabicChars;
  final int englishChars;
  final int otherChars;

  LanguageDetectionResult({
    required this.language,
    required this.confidence,
    required this.arabicChars,
    required this.englishChars,
    required this.otherChars,
  });

  @override
  String toString() {
    return 'LanguageDetectionResult(language: $language, confidence: ${(confidence * 100).toStringAsFixed(1)}%, arabicChars: $arabicChars, englishChars: $englishChars, otherChars: $otherChars)';
  }
}