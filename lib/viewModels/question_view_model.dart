import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leben_in_deutschland/cache/questions_cache_manager.dart';
import 'package:leben_in_deutschland/constants/list_constants.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/models/question_model.dart';

class QuestionViewModel extends ChangeNotifier {
  List<QuestionModel> questions = [];
  List<List<QuestionModel>> statesQuestions = [];

  final QuestionsCacheManager _questionCacheManager = QuestionsCacheManager();

  QuestionViewModel() {
    controlDataInHive();
    //getStatesQuestionsJson();
  }

  void controlDataInHive() {
    _questionCacheManager.init();

    if (_questionCacheManager.questionsBox!.isEmpty) {
      getQuestionsFromJson().then((value) => getStatesQuestionsJson().then(
          (value) async => await _questionCacheManager.putAllItems(questions)));
    } else {
      getAllItems();
    }
  }

  Future<void> putItem(QuestionModel questionModel) async {
    await _questionCacheManager.putItem(questionModel);
    getAllItems();
  }

  void getAllItems() {
    questions = _questionCacheManager.getAllItems()!;
    notifyListeners();
  }

  List<QuestionModel> getPinnedQuestions() {
    return _questionCacheManager.getPinnedItems();
  }

  Future<void> getQuestionsFromJson() async {
    try {
      final String response = await rootBundle.loadString(lidQuestionsPath);
      final data = await json.decode(response);
      for (var i = 0; i < data.length; i++) {
        questions.add(QuestionModel.fromJson(data[i]));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> getStatesQuestionsJson() async {
    try {
      for (var i = 0; i < statesQuestionsPaths.length; i++) {
        final String response =
            await rootBundle.loadString(statesQuestionsPaths[i]);
        final data = await json.decode(response);
        for (var k = 0; k < data.length; k++) {
          questions.add(QuestionModel.fromJson(data[k]));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
