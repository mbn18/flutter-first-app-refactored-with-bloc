import 'dart:math';

import 'package:epoch_flutter_words/src/bloc/block.dart';
import 'package:epoch_flutter_words/src/bloc/word_list/word_bloc.dart';
import 'package:epoch_flutter_words/src/entity/word.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  final bloc = WordBloc();

  Widget build(BuildContext context) {
    final _app = MaterialApp(
      title: 'Welcome to Flutter!',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        backgroundColor: Colors.red,
        brightness: Brightness.dark,
      ),
      home: RandomWords(),
    );

    return BlocProvider<WordBloc>(
      bloc: bloc,
      child: _app,
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _textStyle = const TextStyle(fontSize: 18.0);

  final Set<Word> _saved = Set<Word>();

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WordBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Startup Name Generator! ' + _random.nextInt(100).toString()),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: StreamBuilder<List<Word>>(
            stream: bloc.wordList.list,
            initialData: List<Word>(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return _buildSuggestions(snapshot.data, bloc);
            }));
  }

  void _pushSaved() {
    final bloc = BlocProvider.of<WordBloc>(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(title: Text('Favorite list')),
              body: StreamBuilder<List<Word>>(
                  stream: bloc.favoriteWordList.list,
                  initialData: List<Word>(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return _buildSuggestions(snapshot.data, bloc);
                  }));
        },
      ),
    );
  }

  Widget _buildSuggestions(List<Word> list, WordBloc bloc) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(color: Colors.orangeAccent);

          final index = i ~/ 2;
          if (index >= list.length) {
            bloc.wordGenerator.generate.add(null);
          } else {
            Word currentWord = list[index];
            return buildRow(currentWord, _textStyle, i, bloc);
          }
        });
  }

  ListTile buildRow(Word word, TextStyle textStyle, int index, WordBloc bloc) {
    return ListTile(
      title: Text(word.word, style: textStyle),
      trailing: Icon(
        word.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: word.isFavorite ? Colors.red : null,
      ),
      onTap: () {
        bloc.toggle.action.add(word);
      },
    );
  }
}
