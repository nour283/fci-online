import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';

class AppStrings {
  static String title1(BuildContext context) =>
      isArabic(context) ? 'العديد من الدورات التجريبية المجانية' : 'Numerous free \ntrial courses';

  static String title2(BuildContext context) =>
      isArabic(context) ? 'تعلم سريع وسهل' : 'Quick and easy \nlearning';

  static String title3(BuildContext context) =>
      isArabic(context) ? 'أنشئ خطة دراسية خاصة بك' : 'Create your own \nstudy plan';

  static String subtitle1(BuildContext context) =>
      isArabic(context) ? 'دورات مجانية لمساعدتك في طريقك للتعلم' : 'Free courses for you to \nfind your way to learning';

  static String subtitle2(BuildContext context) =>
      isArabic(context) ? 'تعلم بسهولة وسرعة في أي وقت لتحسين مهاراتك' : 'Easy and fast learning at \nany time to help you \nimprove various skills';

  static String subtitle3(BuildContext context) =>
      isArabic(context) ? 'ادرس حسب خطة دراسية لزيادة الحماس' : 'Study according to the \nstudy plan, make study \nmore motivated';

  static String skip(BuildContext context) =>
      isArabic(context) ? 'تخطي' : 'Skip';

  static String enterNumber(BuildContext context) =>
      isArabic(context) ? 'أدخل رقم هاتفك' : 'Enter Your Phone Number';

  static String continueText(BuildContext context) =>
      isArabic(context) ? 'استمرار' : 'Continue';

  static String number(BuildContext context) =>
      isArabic(context) ? '+20 100 000 0000' : '+63 283 835 2999';

  static String forget(BuildContext context) =>
      isArabic(context) ? 'نسيت كلمة المرور' : 'Forget Password';

  static String phoneNumberError(BuildContext context) =>
      isArabic(context) ? 'يجب إدخال رقم مكون من 11 رقمًا' : 'You must enter an 11-digit number';

  static String verifyPhone(BuildContext context) =>
      isArabic(context) ? 'تأكيد الهاتف' : 'Verify Phone';

  static String codeSent(BuildContext context) =>
      isArabic(context) ? 'تم إرسال الكود إلى' : 'Code is sent to';

  static String verifyAndCreate(BuildContext context) =>
      isArabic(context) ? 'تأكيد وإنشاء الحساب' : 'Verify and Create Account';

  static String signUp(BuildContext context) =>
      isArabic(context) ? 'إنشاء حساب' : 'Sign Up';

  static String enterDetails(BuildContext context) =>
      isArabic(context) ? 'أدخل بياناتك بالأسفل وسجّل مجانًا' : 'Enter your details below & free sign up';

  static String yourEmail(BuildContext context) =>
      isArabic(context) ? 'بريدك الإلكتروني' : 'Your Email';

  static String emailHint(BuildContext context) =>
      isArabic(context) ? 'example@email.com' : 'Cooper_Kristin@gmail.com';

  static String password(BuildContext context) =>
      isArabic(context) ? 'كلمة المرور' : 'Password';

  static String passwordHint(BuildContext context) =>
      isArabic(context) ? '************' : '************';

  static String mobilePhone(BuildContext context) =>
      isArabic(context) ? 'رقم الهاتف' : 'Mobile phone';

  static String mobileHint(BuildContext context) =>
      isArabic(context) ? '+20' : '+201';

  static String createAccount(BuildContext context) =>
      isArabic(context) ? 'إنشاء حساب' : 'Create account';

  static String agreeTerms(BuildContext context) =>
      isArabic(context) ? 'بإنشائك لحساب، فإنك توافق على الشروط والأحكام الخاصة بنا.' :
      'By creating an account you have to agree with our terms & conditions.';

  static String alreadyHaveAccount(BuildContext context) =>
      isArabic(context) ? 'هل لديك حساب بالفعل؟' : 'Already have an account?';

  static String logIn(BuildContext context) =>
      isArabic(context) ? 'تسجيل الدخول' : 'Log in';

  static String forgetPassword(BuildContext context) =>
      isArabic(context) ? 'هل نسيت كلمة المرور؟' : 'Forget password?';

  static String dontHaveAccount(BuildContext context) =>
      isArabic(context) ? 'ليس لديك حساب؟' : "Don't have an account?";

  static String orLoginWith(BuildContext context) =>
      isArabic(context) ? 'أو سجل الدخول باستخدام' : 'Or login with';

  static String newPassword(BuildContext context) =>
      isArabic(context) ? 'كلمة مرور جديدة' : 'New password';

  static String confirmPassword(BuildContext context) =>
      isArabic(context) ? 'تأكيد كلمة المرور' : 'Confirm password';

  static String submit(BuildContext context) =>
      isArabic(context) ? 'إرسال' : 'Submit';

  static String generate(BuildContext context) =>
      isArabic(context) ? 'أنشئ اختبارات لوحدة الوظيفة التالية بـ C#' : 'Generate unittests for\n the following C# \nfunction';

  static String generate2(BuildContext context) =>
      isArabic(context) ? 'أنشئ اختبارات لوحدة الوظيفة التالية بـ C#' : 'Generate unit tests for\n the following C#\n function';

  static String enterPrompt(BuildContext context) =>
      isArabic(context) ? 'أدخل الأمر هنا' : 'Enter a prompt here';

  static String fill(BuildContext context) =>
      isArabic(context) ? 'يسعدنا أن نسمع منك. من فضلك املأ هذا النموذج.' :
      'We’d love to hear from you. Please fill out this form.';

  static String getTouch(BuildContext context) =>
      isArabic(context) ? 'ابقَ على تواصل' : 'Get in touch';

  static String name(BuildContext context) =>
      isArabic(context) ? 'الاسم' : 'Name';

  static String companyEmail(BuildContext context) =>
      isArabic(context) ? 'البريد الإلكتروني للشركة' : 'Company email';

  static String phoneNumber(BuildContext context) =>
      isArabic(context) ? 'رقم الهاتف' : 'Phone number';

  static String appName(BuildContext context) =>
      isArabic(context) ? "تطبيق الكتب" : "Book App";

  static String greeting(BuildContext context) =>
      isArabic(context) ? "مرحبًا ، عزيزي 👋" : "Hello , Dear 👋";

  static String searchHint(BuildContext context) =>
      isArabic(context) ? "ابحث هنا" : "Search here";

  static String noBooksAvailable(BuildContext context) =>
      isArabic(context) ? "لا توجد كتب متاحة" : "No books available";

  static String microphonePermissionDenied(BuildContext context) =>
      isArabic(context)
          ? "يجب السماح بالوصول للميكروفون"
          : "Microphone access must be granted";

  static String speechNotAvailable(BuildContext context) =>
      isArabic(context)
          ? "البحث الصوتي غير متاح"
          : "Voice search is not available";

  static String clearSearch(BuildContext context) =>
      isArabic(context) ? "مسح البحث" : "Clear search";

  static String listening(BuildContext context) =>
      isArabic(context) ? "جاري الاستماع..." : "Listening...";

  static String pythonBookTitle(BuildContext context) =>
      isArabic(context) ? 'البرمجة بلغة البايثون' : 'Python Programming';

  static String gameDevBookTitle(BuildContext context) =>
      isArabic(context) ? 'برمجة الألعاب الإلكترونية' : 'Game Development';

  static String psychologyBookTitle(BuildContext context) =>
      isArabic(context) ? 'إزالة القلق' : 'Overcoming Anxiety';

  static String autocadBookTitle(BuildContext context) =>
      isArabic(context) ? 'أساسيات أوتوكاد' : 'AutoCAD Basics';

  static String aiBookTitle(BuildContext context) =>
      isArabic(context) ? 'الذكاء الاصطناعي المتوافق مع البشر' : 'Human-Compatible AI';

  static String marketingBookTitle(BuildContext context) =>
      isArabic(context) ? 'التسويق الإلكتروني' : 'Digital Marketing';

  static String excelBookTitle(BuildContext context) =>
      isArabic(context) ? 'إتقان الإكسل' : 'Excel Mastery';

  static String choose(BuildContext context) => isArabic(context) ? 'اختر' : 'Choice';

  static String favoriteCourse(BuildContext context) => isArabic(context) ? 'الدورة المفضلة' : 'Favorite Course';

  static String recommendedForYou(BuildContext context) => isArabic(context) ? 'موصى لك' : 'Recommended for you';

  // Course Titles
  static String uiUxDesign(BuildContext context) => isArabic(context) ? 'تصميم واجهات' : 'UI UX DESIGN';

  static String python(BuildContext context) => isArabic(context) ? 'بايثون' : 'Python';

  static String eCommerce(BuildContext context) => isArabic(context) ? 'التجارة الإلكترونية' : 'E-commerce';

  static String java(BuildContext context) => isArabic(context) ? 'جافا' : 'Java';

  static String programming(BuildContext context) => isArabic(context) ? 'برمجة' : 'Programming';

  static String design(BuildContext context) => isArabic(context) ? 'تصميم' : 'Design';

  static String development(BuildContext context) => isArabic(context) ? 'تطوير' : 'Development';

  static String business(BuildContext context) => isArabic(context) ? 'إدارة الأعمال' : 'Business';

  static String marketing(BuildContext context) => isArabic(context) ? 'تسويق' : 'Marketing';

  // Course Descriptions
  static String uiUxDesignDescription(BuildContext context) => isArabic(context)
      ? 'تعلم تصميم المواقع بطريقة احترافية تجعلك مؤهلًا للسوق.'
      : 'Learn website design with great professionalism that will make you qualified for the labor market.';

  static String pythonDescription(BuildContext context) => isArabic(context)
      ? 'تعلم البرمجة بلغة بايثون، تصميم قواعد البيانات، وإنشاء تطبيقات إنترنتية.'
      : 'Learn how to code in Python, design and access databases, create interactive web applications.';

  static String eCommerceDescription(BuildContext context) => isArabic(context)
      ? 'تعلّم إدارة الأعمال واستراتيجيات التسويق التي تُعتبر مفتاح التشغيل عبر الإنترنت.'
      : 'Teach business management and marketing strategy skills, key to successfully operating an online business.';

  static String javaDescription(BuildContext context) => isArabic(context)
      ? 'دورات تغطي المهارات في البرمجة الكائنية التوجه، وتطوير البرامج، وإنشاء التطبيقات.'
      : 'Courses that cover skills in object-oriented programming, software development, and app creation.';

  static String cppDescription(BuildContext context) => isArabic(context)
      ? 'تعلم أساسيات البرمجة بلغة C++ وإنشاء التطبيقات.'
      : 'Learn the basics of C++ programming and application development.';

  static String photoshopDescription(BuildContext context) => isArabic(context)
      ? 'كن مبدعًا بإنشاء هوية خاصة بك.'
      : 'Be innovative and creative by creating your own identity.';

  static String illustratorDescription(BuildContext context) => isArabic(context)
      ? 'تعلّم تصميم الخطوط وإنشاء شعارك بشكل احترافي.'
      : 'Learn to design fonts and create your own logo professionally.';

  static String xdDescription(BuildContext context) => isArabic(context)
      ? 'أداة تصميم للمواقع والتطبيقات.'
      : 'A vector design tool for web and mobile applications.';

  static String softwareDevDescription(BuildContext context) => isArabic(context)
      ? 'دورات تطوير البرمجيات لتتعلم كيفية إنشاء برامجك الخاصة.'
      : 'Software development courses to learn how to create their own software programs.';

  static String eBusinessDescription(BuildContext context) => isArabic(context)
      ? 'إدارة أي عمل باستخدام الإنترنت، الإكسانترنت، الويب، والإنترانت.'
      : 'The administration of conducting any business using the internet, extranet, web, and intranet';

  static String marketingBasicDescription(BuildContext context) => isArabic(context)
      ? 'فهم احتياجات العملاء وتلبية تلك الاحتياجات عن طريق الشركة.'
      : 'Understanding the needs of customers, and communicating how a business meets those needs';

  static String designDescription(BuildContext context) => isArabic(context)
      ? 'تعلم تصميم الواجهات والرسومات باستخدام أحدث الأدوات.'
      : 'Learn interface design and graphics using the latest tools.';

  static String developmentDescription(BuildContext context) => isArabic(context)
      ? 'تعلم تطوير البرمجيات والتطبيقات بمختلف أنواعها.'
      : 'Learn software and application development of various types.';

  static String businessDescription(BuildContext context) => isArabic(context)
      ? 'إدارة الأعمال والتسويق الرقمي لنجاح مشروعك.'
      : 'Business management and digital marketing for your project success.';

  static String marketingDescription(BuildContext context) => isArabic(context)
      ? 'استراتيجيات التسويق الحديثة لتعزيز وجودك الرقمي.'
      : 'Modern marketing strategies to enhance your digital presence.';

  // Strings added for CourseDetailsPage and related widgets
  static String hoursLeftPrice(BuildContext context) =>
      isArabic(context) ? '11 ساعة متبقية بهذا السعر' : '11 hour left at this price';

  static String studyNow(BuildContext context) =>
      isArabic(context) ? 'ادرس الآن' : 'Study now';

  static String courseIncluded(BuildContext context) =>
      isArabic(context) ? 'هذه الدورة تتضمن' : 'This Course included';

  static String bestQuality(BuildContext context) =>
      isArabic(context) ? 'أفضل جودة' : 'The best quality';

  static String accessAllDevices(BuildContext context) =>
      isArabic(context) ? 'الوصول على جميع الأجهزة' : 'Access on all devices';

  static String certificationCompletion(BuildContext context) =>
      isArabic(context) ? 'شهادة إتمام' : 'Certification of completion';

  static String modulesCount(BuildContext context, int count) =>
      isArabic(context) ? '$count وحدة' : '$count Modules';

  static String adobePhotoshop(BuildContext context) =>
      isArabic(context) ? 'أدوبي فوتوشوب' : 'Adobe Photoshop';

  static String adobeIllustrator(BuildContext context) =>
      isArabic(context) ? 'أدوبي إليستريتور' : 'Adobe Illustrator';

  static String adobeXd(BuildContext context) =>
      isArabic(context) ? 'أدوبي XD' : 'Adobe XD';

  static String eBusiness(BuildContext context) =>
      isArabic(context) ? 'الأعمال الإلكترونية' : 'E-Business';

  // Strings added for LayoutScreen (Drawer and Bottom Navigation Bar)
  static String homeDrawerLabel(BuildContext context) => isArabic(context) ? 'الرئيسية' : 'Home';

  static String aiDrawerLabel(BuildContext context) => isArabic(context) ? 'ذكاء اصطناعي' : 'AI';

  static String bookDrawerLabel(BuildContext context) => isArabic(context) ? 'كتاب' : 'Book';

  static String partnerDrawerLabel(BuildContext context) => isArabic(context) ? 'شركاء' : 'Partner';

  static String programDrawerLabel(BuildContext context) => isArabic(context) ? 'برنامج' : 'Program';

  static String aboutUsDrawerLabel(BuildContext context) => isArabic(context) ? 'معلومات عنا' : 'About Us';

  static String logoutButtonLabel(BuildContext context) => isArabic(context) ? 'تسجيل الخروج' : 'Log out';

  static String homeBottomNavLabel(BuildContext context) => isArabic(context) ? 'الرئيسية' : 'Home';

  static String courseBottomNavLabel(BuildContext context) => isArabic(context) ? 'الدورات' : 'Course';

  static String aiAssistantBottomNavLabel(BuildContext context) => isArabic(context) ? 'مساعد الذكاء الاصطناعي' : 'AI Assistant';

  static String contactUsBottomNavLabel(BuildContext context) => isArabic(context) ? 'اتصل بنا' : 'Contact Us';

  static String accountBottomNavLabel(BuildContext context) => isArabic(context) ? 'الحساب' : 'Account';

  // ** النصوص التي كانت مفقودة وتمت إضافتها هنا **
  static String fullName(BuildContext context) =>
      isArabic(context) ? 'الاسم الكامل' : 'Full Name';

  static String nameHint(BuildContext context) =>
      isArabic(context) ? 'أدخل اسمك الكامل' : 'Enter your full name';

  static String nameError(BuildContext context) =>
      isArabic(context) ? 'يرجى إدخال الاسم' : 'Please enter your name';

  static String emailError(BuildContext context) =>
      isArabic(context) ? 'يرجى إدخال بريد إلكتروني صالح' : 'Please enter a valid email';

  static String phoneError(BuildContext context) =>
      isArabic(context) ? 'يرجى إدخال رقم هاتف صالح' : 'Please enter a valid phone number';

  static String passwordError(BuildContext context) =>
      isArabic(context) ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Password must be at least 6 characters';

  static String loading(BuildContext context) =>
      isArabic(context) ? 'جاري التحميل...' : 'Loading...';

  static bool isArabic(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return languageProvider.isArabic;
  }
}
