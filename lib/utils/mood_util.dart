import 'package:flutter/material.dart';

enum Mood {
  angry, // Tức giận
  sad, // Buồn
  depressed, // Trầm tính
  worried, // Lo lắng
  happy, // Hạnh phúc
  excited, // Lúng túng
  confused, // Bối rối
  bored, // Chán
  annoyed, // Bực bội
  tired, // Thư giãn
}

extension MoodExtension on Mood {
  String get emoji {
    switch (this) {
      case Mood.angry:
        return '😡';
      case Mood.sad:
        return '😢';
      case Mood.depressed:
        return '😞';
      case Mood.worried:
        return '😟';
      case Mood.happy:
        return '😊';
      case Mood.excited:
        return '😕';
      case Mood.confused:
        return '🤔';
      case Mood.bored:
        return '😐';
      case Mood.annoyed:
        return '😠';
      case Mood.tired:
        return '😩';
    }
  }

  Color get color {
    switch (this) {
      case Mood.angry:
        return Colors.red;
      case Mood.sad:
        return Colors.blue;
      case Mood.depressed:
        return Colors.green;
      case Mood.worried:
        return Colors.purple;
      case Mood.happy:
        return Colors.yellow;
      case Mood.excited:
        return Colors.teal;
      case Mood.confused:
        return Colors.cyan;
      case Mood.bored:
        return Colors.grey;
      case Mood.annoyed:
        return Colors.orange;
      case Mood.tired:
        return Colors.lime;
    }
  }

  String get description {
    switch (this) {
      case Mood.angry:
        return 'Tức giận';
      case Mood.sad:
        return 'Buồn';
      case Mood.depressed:
        return 'Trầm tính';
      case Mood.worried:
        return 'Lo lắng';
      case Mood.happy:
        return 'Hạnh phúc';
      case Mood.excited:
        return 'Lúng túng';
      case Mood.confused:
        return 'Bối rối';
      case Mood.bored:
        return 'Chán';
      case Mood.annoyed:
        return 'Bực bội';
      case Mood.tired:
        return 'Thư giãn';
    }
  }
}
