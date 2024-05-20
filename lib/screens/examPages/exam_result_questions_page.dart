import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/viewModels/exam_result_view_model.dart';
import 'package:leben_in_deutschland/widgets/question_widget.dart';
import 'package:provider/provider.dart';

class ExamResultQuestionsPage extends StatelessWidget {
  const ExamResultQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExamResultViewModel examResultViewModel = Provider.of<ExamResultViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PageView.builder(
          itemCount: examResultViewModel.examResult.answeredQuestions.length,
          itemBuilder: (context, index) {
            return _buildQuestionPages(examResultViewModel.examResult.answeredQuestions[index]["question"]);
          },
          allowImplicitScrolling: true,
        ),
      ),
    );
  }

  Widget _buildQuestionPages(QuestionModel question) {
    return QuestionWidget(question.id, PageType.examResultQuestionPage);
  }
}
