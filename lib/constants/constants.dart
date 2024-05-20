import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/models/bottom_navbar_item_model.dart';
import 'package:leben_in_deutschland/models/home_menu_item_model.dart';
import 'package:leben_in_deutschland/screens/constitution_page.dart';
import 'package:leben_in_deutschland/screens/examPages/all_exam_results_page.dart';
import 'package:leben_in_deutschland/screens/questionsPages/all_questions.dart';
import 'package:leben_in_deutschland/screens/questionsPages/pinned_questions_page.dart';
import 'package:leben_in_deutschland/screens/settingsPages/settings_page.dart';
import 'package:leben_in_deutschland/screens/stateQuestionsPages/choose_state_page.dart';

HomeMenuItemModel constitutionMenuItemModel = HomeMenuItemModel(
  title: constitutionButtonText,
  navigatePageName: const ConstitutionPage(),
);

HomeMenuItemModel allQuestionsMenuItemModel = HomeMenuItemModel(
  title: allQuestionsButtonText,
  navigatePageName: const AllQuestions(),
);

HomeMenuItemModel stateQuestionsMenuItemModel = HomeMenuItemModel(
  title: stateQuestionsButtonText,
  navigatePageName: const ChooseStatePage(PageType.stateQuestionPage),
);


//BottomNavbarItemModel homeNavbarItemModel = BottomNavbarItemModel(icon: const Icon(Icons.home), navigatePageName: const HomePage());
BottomNavbarItemModel pinnedQuestionsNavbarItemModel = BottomNavbarItemModel(
  icon: const Icon(Icons.push_pin_rounded),
  navigatePageName: const PinnedQuestionsPage(),
);
BottomNavbarItemModel allExamResultNavbarItemModel = BottomNavbarItemModel(
  icon: const Icon(Icons.equalizer_rounded),
  navigatePageName: const AllExamResultsPage(),
);
BottomNavbarItemModel settingsNavbarItemModel = BottomNavbarItemModel(
  icon: const Icon(Icons.settings),
  navigatePageName: const SettingsPage(),
);
