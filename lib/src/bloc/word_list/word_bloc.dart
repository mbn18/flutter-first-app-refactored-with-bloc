import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:epoch_flutter_words/src/bloc/block.dart';
import 'package:rxdart/rxdart.dart';

class WordBloc extends BlocBase {
  List<WordPair> _list;

  Stream<List<WordPair>> get words => _wordsController;

  final BehaviorSubject<List<WordPair>> _wordsController =
      BehaviorSubject<List<WordPair>>();

  StreamSink get generateWords => _generateController.sink;

  final StreamController _generateController = StreamController();

  WordBloc() {
    _list = List<WordPair>();
    _list.addAll(generateWordPairs().take(10));
    _wordsController.sink.add(_list);

    _generateController.stream.listen(_generateWords);
  }

  void _generateWords(data) {
    print("Generating words!");
    _list.addAll(generateWordPairs().take(10));
    _wordsController.sink.add(_list);
  }

  @override
  void dispose() {
    _generateController.close();
    _wordsController.close();
  }
}
