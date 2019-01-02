import 'dart:async';
import 'dart:collection';

import 'package:epoch_flutter_words/src/bloc/block.dart';
import 'package:epoch_flutter_words/src/entity/word.dart';
import 'package:rxdart/rxdart.dart';

class WordBloc extends BlocBase {
  LinkedHashSet<Word> _list;
  LinkedHashSet<Word> _favoriteList;

  final toggle = _WordToggleBloc();
  final wordList = _WordListBloc();
  final favoriteWordList = _FavoriteWordListBloc();
  final wordGenerator = _GenerateWordBloc();

  WordBloc() {
    if (_list == null) {
      _list = LinkedHashSet<Word>();
    }
    if (_favoriteList == null) {
      _favoriteList = LinkedHashSet<Word>();
    }

    _dispatchWords();

    wordGenerator._controller.stream.listen(_generateWordsAndDispatch);
    toggle._controller.stream.listen(_toggleFavorite);
  }

  void _generateWordsAndDispatch(data) {
    _list.addAll(generateWordList(10));
    _dispatchWords();
  }

  void _toggleFavorite(Word word) {
    word.isFavorite = !word.isFavorite;
    word.isFavorite ? _favoriteList.add(word) : _favoriteList.remove(word);
    favoriteWordList._controller.sink.add(_favoriteList.toList());
    _dispatchWords();
  }

  void _dispatchWords() {
    wordList._controller.sink.add(_list.toList());
  }

  @override
  void dispose() {
    toggle._controller.close();
    wordList._controller.close();
    favoriteWordList._controller.close();
    wordGenerator._controller.close();
  }
}

class _GenerateWordBloc extends BlocBase {
  StreamSink get generate => _controller.sink;

  final StreamController _controller = StreamController();

  @override
  void dispose() {
    _controller.close();
  }
}

class _WordListBloc extends BlocBase {
  Stream<List<Word>> get list => _controller;

  final BehaviorSubject<List<Word>> _controller = BehaviorSubject<List<Word>>();

  @override
  void dispose() {
    _controller.close();
  }
}

class _FavoriteWordListBloc extends BlocBase {
  Stream<List<Word>> get list => _controller;

  final BehaviorSubject<List<Word>> _controller = BehaviorSubject<List<Word>>();

  @override
  void dispose() {
    _controller.close();
  }
}

class _WordToggleBloc extends BlocBase {
  final StreamController<Word> _controller = StreamController();

  StreamSink get action => _controller.sink;

  @override
  void dispose() {
    _controller.close();
  }
}
