import 'package:english_words/english_words.dart';

class Word {
  String word;
  bool isFavorite = false;

  Word(String word) {
    this.word = word;
  }
}

Iterable<Word> generateWordList(int total) {
  List<Word> list = List<Word>();
  generateWordPairs().take(10).forEach((f) => list.add(Word(f.asPascalCase)));

  return list;
}
