import 'dart:developer';

import 'package:cu_quiz_app/services/database_service.dart';
import 'package:cu_quiz_app/ui/widgets/dialogs.dart';
import 'package:cu_quiz_app/ui/widgets/question_page.dart';
import 'package:cu_quiz_app/ui/widgets/questions_controls.dart';
import 'package:cu_quiz_app/ui/widgets/test_timer.dart';
import 'package:cu_quiz_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  final List testQuestions;
  final int testTime;

  const QuestionsScreen(
      {Key? key, required this.testQuestions, required this.testTime})
      : super(key: key);

  static final pageController = PageController(keepPage: true, initialPage: 0);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int correctAnsCounter = 0;
  Map<int, int> score = {};

  @override
  Widget build(BuildContext context) {
    /// Todo: Work on back press dialog
    return WillPopScope(
      onWillPop: () async {
        bool pop = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const ExitTestDialog()) ??
            false;
        return pop;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Computer Networks"),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: TestTimer(
                  time: widget.testTime,
                )),
              )
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: allQuestionPages()),
              // const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: QuestionsControls(
                  noOfQuestions: widget.testQuestions.length,
                  pageController: QuestionsScreen.pageController,
                  onSubmit: () async {
                    bool pop = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => SubmitTestDialog(
                                  onSubmit: () async {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => const LoadingDialog(
                                            text: "Submitting Test..."));
                                    await DBService.instance.submitTestScore(
                                        maxMarks: widget.testQuestions.length,
                                        marksObtained: getObtainedMarks());
                                    Utils.instance.showToast(message: "Test Submitted Successfully!");
                                    await Future.delayed(const Duration(milliseconds: 600));
                                    Navigator.pop(context, true);
                                  },
                                )) ??
                        false;
                    if (pop) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          )),
    );
  }

  int getObtainedMarks() {
    var scoreCounter = 0;
    score.forEach((key, value) {
      scoreCounter += value;
    });
    log("marks obtained is:- $scoreCounter");
    return scoreCounter;
  }

  Widget allQuestionPages() {
    return PageView.builder(
        itemCount: widget.testQuestions.length,
        controller: QuestionsScreen.pageController,
        itemBuilder: (ctx, index) {
          return Container(
              key: Key(index.toString()),
              child: QuestionPage(
                totalQuestions: widget.testQuestions.length,
                questionIndex: index,
                question: widget.testQuestions[index],
                key: Key("${widget.testQuestions[index]['question']} + $index"),
                isMarkedAnswerCorrect: (bool isCorrect) {
                  score[index] = isCorrect ? 1 : 0;
                  log(score.toString());
                },
              ));
        });
  }
}
