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
