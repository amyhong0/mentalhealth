import 'package:flutter/material.dart';
import '../models/emotion.dart';
import 'flip_card.dart';

class EmotionCard extends StatelessWidget {
  final Emotion emotion;
  final bool isSelected;
  final VoidCallback onSelect;

  const EmotionCard({
    Key? key,
    required this.emotion,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: _buildCardFace(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              emotion.imagePath,
              height: 80,
              width: 80,
            ),
            SizedBox(height: 16),
            Text(
              emotion.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      back: _buildCardFace(
        color: emotion.category == '긍정' ? Colors.green[100]! : Colors.red[100]!,
        child: Center(
          child: Text(
            emotion.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: emotion.category == '긍정' ? Colors.green[800] : Colors.red[800],
            ),
          ),
        ),
      ),
      onFlip: onSelect,
      isFront: !isSelected,
    );
  }

  Widget _buildCardFace({required Color color, required Widget child}) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }
}
