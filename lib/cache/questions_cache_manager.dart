import 'package:hive/hive.dart';
import 'package:leben_in_deutschland/models/question_model.dart';

class QuestionsCacheManager {
  Box<QuestionModel>? _questionsBox;

  static final QuestionsCacheManager _questionsCacheManager =
      QuestionsCacheManager.internal();

  factory QuestionsCacheManager() {
    return _questionsCacheManager;
  }
  QuestionsCacheManager.internal();

  Box<QuestionModel>? get questionsBox => _questionsBox;

  Future<void> init() async {
    _questionsBox = Hive.box<QuestionModel>("allQuestions");
  }

  Future<void> putItem(QuestionModel questionModel) async {
    await _questionsBox?.put(questionModel.id, questionModel);
  }

  Future<void> putAllItems(List<QuestionModel> allQuestionModels) async {
    await _questionsBox?.putAll(
        Map.fromEntries(allQuestionModels.map((e) => MapEntry(e.id, e))));
  }

  QuestionModel? getItem(int key) {
    return _questionsBox?.get(key);
  }

  List<QuestionModel>? getAllItems() {
    return _questionsBox?.values.toList();
  }

  List<QuestionModel> getPinnedItems() {
    List<QuestionModel>? pinnedQuestions = [];
    pinnedQuestions =
        _questionsBox?.values.where((element) => element.isPinned!).toList();
    return pinnedQuestions!;
  }

  void closeBox() {
    _questionsBox?.close();
  }
}
