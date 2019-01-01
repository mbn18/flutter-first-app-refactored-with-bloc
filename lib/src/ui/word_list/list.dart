import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:epoch_flutter_words/src/bloc/block.dart';
import 'package:epoch_flutter_words/src/bloc/word_list/word_bloc.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
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
      bloc: WordBloc(),
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
  final Set<WordPair> _saved = Set<WordPair>();

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
        body: StreamBuilder<List<WordPair>>(
            stream: bloc.words,
            initialData: List<WordPair>(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return _buildSuggestions(snapshot.data, bloc);
            }));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return buildRow(pair, _textStyle, false);
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions(List<WordPair> list, WordBloc bloc) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= list.length) {
            bloc.generateWords.add(null);
          } else {
            WordPair currentWord = list[index];
            return buildRow(
                currentWord, _textStyle, _saved.contains(currentWord));
          }
        });
  }

  ListTile buildRow(WordPair pair, TextStyle textStyle, bool favorite) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: textStyle,
      ),
      trailing: Icon(
        favorite ? Icons.favorite : Icons.favorite_border,
        color: favorite ? Colors.red : null,
      ),
      onTap: () {
        print("Tapped");
//      setState(() {
//        if (alreadySaved) {
//          _saved.remove(pair);
//        } else {
//          _saved.add(pair);
//        }
//      });
      },
    );
  }
}
