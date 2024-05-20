import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/style_constants.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/extensions/context_extension.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/viewModels/exam_result_view_model.dart';
import 'package:leben_in_deutschland/viewModels/question_view_model.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class QuestionWidget extends StatefulWidget {
  final int questionID;
  final PageType _pageType;
  const QuestionWidget(this.questionID, this._pageType, {super.key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with AutomaticKeepAliveClientMixin {
  final translator = GoogleTranslator();
  bool? _isAnswered;
  List<Color>? optionColors;
  List<Color>? optionBorderColors;
  int? _selectedQuestionOptionIndex;
  QuestionModel? question;
  bool? _isFirst;

  @override
  void initState() {
    super.initState();
    _isAnswered = false;
    _isFirst = true;
    optionColors = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
    ];
    optionBorderColors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ExamResultViewModel examResultViewModel = Provider.of<ExamResultViewModel>(context);

    final QuestionViewModel questionsViewModel = Provider.of<QuestionViewModel>(context);

    if (context.theme.brightness == Brightness.light && _isAnswered == false && _isFirst == true) {
      optionColors = [
        lightThemeSecondColor,
        lightThemeSecondColor,
        lightThemeSecondColor,
        lightThemeSecondColor,
      ];
      optionBorderColors = [
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
      ];
    }

    question = questionsViewModel.questions[widget.questionID - 1];

    if (widget._pageType == PageType.examResultQuestionPage) {
      _selectedQuestionOptionIndex = examResultViewModel.findQuestionSelectedOptionIndex(widget.questionID);
      controlQuestion(question!, _selectedQuestionOptionIndex, examResultViewModel);
    }

    //translator.translate("Hello", to: 'tr').then(print);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //_buildTranslateButton(),
              widget._pageType != PageType.examPage ? _buildPinButton(questionsViewModel) : const SizedBox(),
            ],
          ),
        ),
        Expanded(
          flex: 15,
          child: Center(
              child: FutureBuilder(
            future: _buildQuestion(examResultViewModel, _selectedQuestionOptionIndex),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data as Widget;
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
        ),
      ],
    );
  }

  // IconButton _buildTranslateButton() {
  //   return IconButton(onPressed: () {}, icon: const Icon(Icons.translate));
  // }

  IconButton _buildPinButton(QuestionViewModel questionsViewModel) {
    return IconButton(
        onPressed: () async {
          question!.isPinned = !(question!.isPinned!);
          questionsViewModel.putItem(question!);
        },
        icon: question!.isPinned! ? const Icon(Icons.push_pin) : const Icon(Icons.push_pin_outlined));
  }

  Widget _buildQuestionNumberCard(int questionID) {
    return Text(
      "Fragen $questionID",
      style: context.primaryTextTheme.headlineSmall!.copyWith(color: const Color.fromRGBO(0, 145, 173, 1)),
    );
  }

  Widget _buildQuestionText(QuestionModel question) {
    return SizedBox(
      width: context.width,
      child: AutoSizeText(
        question.question,
        style: context.primaryTextTheme.headlineSmall,
        //textAlign: TextAlign.start,
        minFontSize: 15,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Column _buildQuestionOptions(QuestionModel question, ExamResultViewModel examResultViewModel, int? selectedQuestionOptionIndex) {
    var sizeGroup = AutoSizeGroup();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (optionIndex) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: optionBorderColors![optionIndex], width: 3),
                ),
                backgroundColor: optionColors![optionIndex],
                alignment: Alignment.center,
                fixedSize: Size(context.width, 60)),
            onPressed: () {
              controlQuestion(question, optionIndex, examResultViewModel);
            },
            child: AutoSizeText(
              question.options[optionIndex]["text"],
              style: context.primaryTextTheme.titleLarge,
              textAlign: TextAlign.center,
              minFontSize: 15,
              group: sizeGroup,
            )),
      ),
    );
  }

  void controlQuestion(QuestionModel question, int? optionIndex, ExamResultViewModel examResultViewModel) {
    if (widget._pageType == PageType.examPage) {
      for (var i = 0; i < optionColors!.length; i++) {
        if (context.theme.brightness == Brightness.light) {
          optionColors![i] = lightThemeSecondColor;
          optionBorderColors![i] = Colors.black;
        } else {
          optionColors![i] = Colors.black;
          optionBorderColors![i] = Colors.white;
        }
      }
      optionColors![optionIndex!] = Colors.grey;
      optionBorderColors![optionIndex] = Colors.white;
      examResultViewModel.changeQuestionSelectedOption(
        question.id,
        optionIndex,
      );
      setState(() {
        _isFirst = false;
      });
    } else {
      if (!_isAnswered!) {
        if (optionIndex != null) {
          if (question.options[optionIndex]["is_Correct"]) {
            optionColors![optionIndex] = Colors.green[200]!;
            optionBorderColors![optionIndex] = Colors.green;
          } else {
            optionColors![optionIndex] = Colors.red[200]!;
            optionBorderColors![optionIndex] = Colors.red;

            for (var i = 0; i < question.options.length; i++) {
              if (question.options[i]["is_Correct"]) {
                optionColors![i] = Colors.green[200]!;
                optionBorderColors![i] = Colors.green;
              }
            }
          }
          _isAnswered = true;

          setState(() {
            _isFirst = false;
          });
        }
      }
    }
  }

  Widget _buildQuestionImage() {
    return SizedBox(
      width: context.width,
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(context.lowValue),
            child: Image.asset("assets/images/${widget.questionID}.jpeg"),
          )),
    );
  }

  Future<Widget> _buildQuestion(ExamResultViewModel examResultViewModel, int? selectedQuestionOptionIndex) async {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.normalValue),
      child: question!.hasImage == true
          ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildQuestionNumberCard(widget.questionID),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildDottedLine(),
                ),
                Expanded(
                  flex: 2,
                  child: _buildQuestionText(question!),
                ),
                Expanded(
                  flex: 4,
                  child: _buildQuestionImage(),
                ),
                Expanded(
                  flex: 8,
                  child: _buildQuestionOptions(question!, examResultViewModel, selectedQuestionOptionIndex),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildQuestionNumberCard(widget.questionID),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildDottedLine(),
                ),
                Expanded(
                  flex: 6,
                  child: _buildQuestionText(question!),
                ),
                Expanded(
                  flex: 8,
                  child: _buildQuestionOptions(question!, examResultViewModel, selectedQuestionOptionIndex),
                ),
                const Spacer()
              ],
            ),
    );
  }

  Widget _buildDottedLine() {
    return Center(
      child: DottedLine(
        dashLength: 10,
        dashGapLength: 10,
        lineThickness: 10,
        dashRadius: 12,
        dashColor: Colors.grey[400]!,
      ),
    );
  }

  // void _translate() async {
  //   await translator.translate(question.question, to: 'tr').then((value) => print(value));
  //   if (widget.isTranslated) {
  //     String tQuestion = await translator
  //         .translate(question.question, to: 'tr')
  //         .then((value) => print(value)) as String;
  //     String tCategory = await translator.translate(question.category, to: 'tr') as String;
  //     List<String> tOptions = [];
  //     for (var i = 0; i < 4; i++) {
  //       tOptions.add(await translator.translate(question.category, to: 'tr') as String);
  //     }
  //     String tCorrect = await translator.translate(question.correctAnswer, to: 'tr') as String;
  //     print(tCorrect);
  //     QuestionModel translatedQuestion = QuestionModel(
  //         id: question.id,
  //         category: tCategory,
  //         question: tQuestion,
  //         options: tOptions,
  //         correctAnswer: tCorrect);
  //     print(translatedQuestion);
  //     return Column(
  //       children: [
  //         _buildQuestionNumberCard(translatedQuestion),
  //         _buildQuestionText(translatedQuestion),
  //         //TODO image
  //         _buildQuestionOptions(translatedQuestion, examResultViewModel),
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         Align(alignment: Alignment.centerLeft, child: _buildQuestionNumberCard(question)),
  //         _buildQuestionText(question),
  //         //TODO image
  //         _buildQuestionOptions(question, examResultViewModel),
  //       ],
  //     );
  //   }
  // }

  @override
  bool get wantKeepAlive => true;
}
