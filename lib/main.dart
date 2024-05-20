import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leben_in_deutschland/cache/dark_mode_cache_manager.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/models/exam_result_model.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/screens/home_page.dart';
import 'package:leben_in_deutschland/services/ad_state.dart';
import 'package:leben_in_deutschland/theme/custom_theme.dart';
import 'package:leben_in_deutschland/viewModels/exam_result_view_model.dart';
import 'package:leben_in_deutschland/viewModels/question_view_model.dart';
import 'package:leben_in_deutschland/widgets/rate_init_widget.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  await Hive.initFlutter();
  Hive.registerAdapter(QuestionModelAdapter());
  Hive.registerAdapter(ExamResultModelAdapter());

  await Hive.openBox<QuestionModel>(allQuestionsBoxName);
  await Hive.openBox<ExamResultModel>(examResultBoxName);
  await Hive.openBox(darkModeBoxName);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => const BetterFeedback(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DarkModeCacheManager darkModeCacheManager = DarkModeCacheManager();
    darkModeCacheManager.init();
    //final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ValueListenableBuilder(
      valueListenable: darkModeCacheManager.getDarkModeBox!.listenable(),
      builder: (context, value, child) {
        var darkMode = darkModeCacheManager.getDarkMode();
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionViewModel>(create: (_) => QuestionViewModel()),
            Provider<ExamResultViewModel>(create: (_) => ExamResultViewModel()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Leben In Deutschland',
            theme: CustomTheme().lightTheme,
            darkTheme: CustomTheme().darkTheme,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            home: RateInitWidget(builder: (rateMyApp) => const HomePage()),
          ),
        );
      },
    );
  }
}
