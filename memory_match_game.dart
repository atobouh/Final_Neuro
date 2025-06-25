import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'dart:async';
import 'package:ff_t/components/neu_button.dart';
import 'package:ff_t/components/memory_card_widget.dart';
import 'package:ff_t/utils/colors.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/text_styles.dart';

class MemoryCardData {
  final String letter;
  final Color color;
  bool isMatched;
  MemoryCardData(
      {required this.letter, required this.color, this.isMatched = false});
}

class MemoryMatchGameScreen extends StatefulWidget {
  const MemoryMatchGameScreen({super.key});
  @override
  State<MemoryMatchGameScreen> createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  late ConfettiController _confettiController;
  List<MemoryCardData> _cards = [];
  List<int> _selectedCardIndices = [];
  List<int> _incorrectIndices = []; // <-- To track wrong pairs
  int _lives = AppConstants.initialMemoryGameLives;
  int _matchesFound = 0;
  bool _isProcessingTurn = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _startGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _lives = AppConstants.initialMemoryGameLives;
      _matchesFound = 0;
      _selectedCardIndices.clear();
      _incorrectIndices.clear();
      _isProcessingTurn = false;
    });
    _generateCards();
  }

  void _generateCards() {
    final List<String> availableLetters = 'ABCDEFGHJKLMNOPQRSTUVWXYZ'.split('');
    final Random random = Random();
    int numberOfPairs = 8;
    List<String> gameLetters = [];
    while (gameLetters.length < numberOfPairs) {
      String letter = availableLetters[random.nextInt(availableLetters.length)];
      if (!gameLetters.contains(letter)) gameLetters.add(letter);
    }
    List<MemoryCardData> tempCards = [];
    for (String letter in gameLetters) {
      Color cardColor =
          dyslexiaWordColors[random.nextInt(dyslexiaWordColors.length)];
      tempCards.add(MemoryCardData(letter: letter, color: cardColor));
      tempCards.add(MemoryCardData(letter: letter, color: cardColor));
    }
    tempCards.shuffle();
    setState(() => _cards = tempCards);
  }

  void _onCardTap(int index) async {
    if (_isProcessingTurn ||
        _cards[index].isMatched ||
        _selectedCardIndices.contains(index)) return;

    setState(() => _selectedCardIndices.add(index));

    if (_selectedCardIndices.length == 2) {
      setState(() => _isProcessingTurn = true);

      final int firstIndex = _selectedCardIndices[0];
      final int secondIndex = _selectedCardIndices[1];
      if (_cards[firstIndex].letter == _cards[secondIndex].letter) {
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _cards[firstIndex].isMatched = true;
          _cards[secondIndex].isMatched = true;
          _matchesFound++;
          _selectedCardIndices.clear();
          _isProcessingTurn = false;
        });
        _checkGameEnd();
      } else {
        // WRONG MATCH FEEDBACK
        setState(() {
          _lives--;
          _incorrectIndices = [firstIndex, secondIndex]; // Store wrong indices
        });
        await Future.delayed(const Duration(milliseconds: 800));
        setState(() {
          _selectedCardIndices.clear();
          _incorrectIndices.clear(); // Clear wrong indices to remove highlight
          _isProcessingTurn = false;
        });
        _checkGameEnd();
      }
    }
  }

  void _checkGameEnd() {
    if (_matchesFound == _cards.length / 2) {
      _confettiController.play();
      _showGameEndDialog('You Won!', 'You matched all the pairs. Well done!',
          accentGreen, Icons.celebration_rounded);
    } else if (_lives <= 0) {
      _showGameEndDialog('Game Over', 'You ran out of lives. Try again!',
          errorRed, Icons.sentiment_dissatisfied_rounded);
    }
  }

  Future<void> _showGameEndDialog(
      String title, String message, Color color, IconData icon) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: primaryDark,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius)),
        title: Text(title,
            style: AppTextStyles.headline3.copyWith(color: color),
            textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message,
              style: AppTextStyles.bodyText1.copyWith(color: lightText),
              textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.defaultPadding),
          Icon(icon, color: color, size: 60),
        ]),
        actions: [
          Center(
              child: NeuButton(
                  text: 'Play Again',
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _startGame();
                  },
                  backgroundColor: accentYellow))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        title: Text('Match the Pairs', style: AppTextStyles.headline3),
        actions: [
          Container(
            // LIVES COUNTER UI
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: primaryDark,
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius)),
            child: Row(children: [
              const Icon(Icons.favorite_rounded, color: errorRed, size: 24),
              const SizedBox(width: AppConstants.smallPadding),
              Text('$_lives',
                  style: AppTextStyles.headline4
                      .copyWith(fontWeight: FontWeight.bold)),
            ]),
          ),
          IconButton(
              icon: const Icon(Icons.refresh_rounded, color: accentBlue),
              onPressed: _startGame,
              tooltip: 'Restart Game'),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding)
                    .copyWith(bottom: 0),
                child: Text('Find and tap the matching pairs of letters.',
                    style: AppTextStyles.bodyText1.copyWith(color: mediumText),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppConstants.defaultPadding,
                      mainAxisSpacing: AppConstants.defaultPadding),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return MemoryCardWidget(
                      letter: card.letter,
                      backgroundColor: card.color,
                      onTap: () => _onCardTap(index),
                      isSelected: _selectedCardIndices.contains(index),
                      isIncorrect: _incorrectIndices
                          .contains(index), // Pass incorrect status
                      isMatched: card.isMatched,
                      isVisible: true,
                    );
                  },
                ),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ],
      ),
    );
  }
}
