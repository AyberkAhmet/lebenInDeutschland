// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/extensions/context_extension.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/screens/examPages/exam_result_page.dart';
import 'package:leben_in_deutschland/services/ad_state.dart';
import 'package:leben_in_deutschland/viewModels/exam_result_view_model.dart';
import 'package:leben_in_deutschland/viewModels/question_view_model.dart';
import 'package:leben_in_deutschland/widgets/question_widget.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

class ExamPage extends StatefulWidget {
  final int selectedStateIndex;
  const ExamPage(this.selectedStateIndex, {super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final controller = PageController();
  List<QuestionModel> _questions = [];
  List<QuestionModel> _examQuestions = [];
  DateTime timeNow = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      adState.createInterstitialAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adState = Provider.of<AdState>(context);

    final ExamResultViewModel examResultViewModel = Provider.of<ExamResultViewModel>(context);

    final QuestionViewModel questionsViewModel = Provider.of<QuestionViewModel>(context);

    _createExamQuestions(questionsViewModel);
    examResultViewModel.createExamResultModel(_examQuestions);

    return Scaffold(
      appBar: AppBar(
        title: SlideCountdown(
          duration: const Duration(minutes: 60),
          onDone: () => endExamAndGoToExamResult(examResultViewModel, adState),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildEndExamButton(context, examResultViewModel, adState),
          )
        ],
      ),
      body: Center(
        child: PageView(
          controller: controller,
          children: _buildQuestionPages(_examQuestions).toList(),
        ),
      ),
    );
  }

  TextButton _buildEndExamButton(BuildContext context, ExamResultViewModel examResultViewModel, AdState adState) {
    return TextButton(
        style: context.theme.elevatedButtonTheme.style!.copyWith(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
        ),
        onPressed: () => _showMaterialDialog(examResultViewModel, adState),
        child: Text(
          endExamButtonText,
          style: context.primaryTextTheme.titleLarge!.copyWith(fontSize: 13),
        ));
  }

  void _createExamQuestions(QuestionViewModel questionsViewModel) {
    for (var i = 0; i < 300; i++) {
      _questions.add(questionsViewModel.questions[i]);
    }
    _questions.shuffle();
    for (var i = 0; i < 30; i++) {
      _examQuestions.add(_questions[i]);
    }
    _questions.clear();
    for (var i = 300 + (widget.selectedStateIndex * 10) + 1; i < 300 + (widget.selectedStateIndex * 10) + 11; i++) {
      _questions.add(questionsViewModel.questions[i]);
    }
    _questions.shuffle();
    for (var i = 0; i < 3; i++) {
      _examQuestions.add(_questions[i]);
    }
    _questions.clear();
  }

  Iterable<Widget> _buildQuestionPages(List<QuestionModel> examQuestions) sync* {
    for (var i = 0; i < examQuestions.length; i++) {
      yield QuestionWidget(examQuestions[i].id, PageType.examPage);
    }
  }

  void endExamAndGoToExamResult(ExamResultViewModel examResultViewModel, AdState adState) {
    examResultViewModel.setTimer(timeNow);
    examResultViewModel.saveExamResult();
    adState.showInterstitialAd();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamResultPage(examResultViewModel.examResult),
        ));
  }

  void _showMaterialDialog(ExamResultViewModel examResultViewModel, AdState adState) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              alertDialogQuestion,
              style: context.primaryTextTheme.titleLarge,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    alertDialogNoButtonText,
                    style: context.primaryTextTheme.titleLarge,
                  )),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  endExamAndGoToExamResult(examResultViewModel, adState);
                  Navigator.pop(context);
                },
                child: Text(
                  alertDialogYesButtonText,
                  style: context.primaryTextTheme.titleLarge,
                ),
              )
            ],
          );
        });
  }
}
