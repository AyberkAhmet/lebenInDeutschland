import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/viewModels/question_view_model.dart';
import 'package:leben_in_deutschland/widgets/question_widget.dart';
import 'package:provider/provider.dart';

class PinnedQuestionsPage extends StatefulWidget {
  const PinnedQuestionsPage({super.key});

  @override
  State<PinnedQuestionsPage> createState() => _PinnedQuestionsPageState();
}

class _PinnedQuestionsPageState extends State<PinnedQuestionsPage> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final QuestionViewModel questionsViewModel = Provider.of<QuestionViewModel>(context);
    List<QuestionModel> questions = questionsViewModel.getPinnedQuestions();

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: PageView(
            controller: controller,
            children: _buildQuestionPages(questions).toList(),
          ),
        ));
  }

  Iterable<Widget> _buildQuestionPages(List<QuestionModel> questions) sync* {
    for (var i = 0; i < questions.length; i++) {
      yield QuestionWidget(questions[i].id, PageType.pinnedQuestionsPage);
    }
  }
}
