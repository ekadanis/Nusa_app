import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../services/quiz_service.dart';
import '../../../models/quiz_models.dart';
import '../../../routes/router.dart'; // Ditambahkan untuk QuizResultRoute
import '../widgets/quiz_timer.dart';
import '../widgets/quiz_exit_dialog.dart';
import '../widgets/quiz_error_view.dart';
import '../widgets/quiz_explanation_sheet.dart';
import '../widgets/question_view.dart';
import '../../../widgets/loading_screen.dart';
import '../../../widgets/back_button.dart';

// Global variable untuk menyimpan quiz result sementara
QuizResult? _latestQuizResult;

// Getter function untuk quiz result
QuizResult? getLatestQuizResult() => _latestQuizResult;

@RoutePage()
class QuizPage extends StatefulWidget {
  final String categoryId;

  const QuizPage({super.key, required this.categoryId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  int correctAnswers = 0;
  Timer? timer;
  Timer? autoAdvanceTimer; // Timer for auto-advancing to next question
  int timeLeft = 18;
  bool isAnswered = false;
  bool isLoading = true;
  bool hasShownExplanation = false; // Track if explanation has been shown
  bool isExplanationVisible =
      false; // Track if explanation is currently being shown
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final loadedQuestions =
          await QuizService.getQuestionsByCategory(widget.categoryId);

      if (loadedQuestions.isEmpty) {
        throw Exception('No questions received from API');
      }

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
      _startTimer();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _startTimer() {
    timer?.cancel();
    setState(() {
      timeLeft = 18;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          _nextQuestion();
        }
      }
    });
  }

  void _selectAnswer(int index) {
    if (isAnswered) return;

    // Cancel timer immediately to prevent race condition
    timer?.cancel();

    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
    });

    final currentQuestion = questions[currentQuestionIndex];
    bool isCorrect = index == currentQuestion.correctAnswerIndex;

    if (isCorrect) {
      setState(() {
        correctAnswers++;
      });
    }

    if (!isCorrect &&
        currentQuestion.explanation != null &&
        currentQuestion.explanation!.isNotEmpty) {
      // Add delay before showing bottom sheet
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted &&
            isAnswered &&
            selectedAnswerIndex == index &&
            !hasShownExplanation &&
            !isExplanationVisible) {
          // Cancel any auto-advance timer when showing explanation
          autoAdvanceTimer?.cancel();

          setState(() {
            hasShownExplanation = true;
            isExplanationVisible = true;
          });
          _showExplanationSheet();
        }
      });
    } else {
      // Auto advance after 2 seconds if no explanation to show
      autoAdvanceTimer = Timer(const Duration(seconds: 2), () {
        if (mounted &&
            isAnswered &&
            selectedAnswerIndex == index &&
            !isExplanationVisible) {
          _nextQuestion();
        }
      });
    }
  }

  void _nextQuestion() {
    // Cancel any existing timers
    timer?.cancel();
    autoAdvanceTimer?.cancel();

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
        hasShownExplanation = false; // Reset explanation state
        isExplanationVisible = false; // Reset visibility state
      });
      _startTimer(); // Start new timer
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    timer?.cancel();

    final result = QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: questions.length - correctAnswers,
      xpEarned: correctAnswers * 10,
      accuracy: (correctAnswers / questions.length) * 100,
      timeTaken: Duration(seconds: (questions.length * 18) - timeLeft),
    );

    // Simpan result ke global variable
    _latestQuizResult = result;

    // Simpan result ke Firebase
    try {
      await QuizService.saveQuizResult(result, widget.categoryId);
    } catch (e) {
      debugPrint('Error saving quiz result to Firebase: $e');
    }    // Navigate to result page
    if (mounted) {
      context.router.replace(const QuizResultRoute());
    }
  }

  void _showExplanationSheet() {
    // Prevent multiple calls
    if (isExplanationVisible) {
      return;
    }

    setState(() {
      isExplanationVisible = true;
    });

    final currentQuestion = questions[currentQuestionIndex];
    final wrongAnswer = selectedAnswerIndex != null
        ? currentQuestion.options[selectedAnswerIndex!]
        : '';
    final correctAnswer =
        currentQuestion.options[currentQuestion.correctAnswerIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => QuizExplanationSheet(
        explanation: currentQuestion.explanation ?? '',
        wrongAnswer: wrongAnswer,
        correctAnswer: correctAnswer,
        isLastQuestion: isLastQuestion,
        onContinue: () {
          Navigator.of(context).pop();
          // Auto advance after closing the sheet
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _nextQuestion();
            }
          });
        },
      ),
    ).then((_) {
      // Handle when bottom sheet is dismissed by swipe down or back gesture
      setState(() {
        isExplanationVisible = false;
      });
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => QuizExitDialog(
        onExit: () {
          Navigator.of(context).pop();
          context.router.back();
        },
        onContinue: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _showExitDialog();
      },
      child: _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    if (isLoading) {
      return const LoadingScreen();
    }

    if (questions.isEmpty || errorMessage.isNotEmpty) {
      return QuizErrorView(
        errorMessage: errorMessage,
        onRetry: _loadQuestions,
        onExit: () => context.router.back(),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: 5.h,
              left: 5.w,
              child: CustomBackButton(
                onPressed: _showExitDialog,
                backgroundColor: Colors.white.withOpacity(0.8),
                iconColor: AppColors.grey90,
              ),
            ),
    
            Positioned(
              top: 5.h,
              right: 5.w,
              child: QuizTimer(timeLeft: timeLeft),
            ),
          ],
        ),
      ),      body: QuestionView(
        question: currentQuestion,
        currentIndex: currentQuestionIndex,
        totalQuestions: questions.length,
        selectedAnswerIndex: selectedAnswerIndex,
        isAnswered: isAnswered,
        onAnswerSelect: _selectAnswer,
        onNextPressed: _nextQuestion,
        isLastQuestion: isLastQuestion,
        onShowExplanation: _showExplanationSheet,
      ),
    );
  }
}
