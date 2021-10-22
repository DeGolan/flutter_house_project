import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../widgets/main_drawer.dart';
import '../providers/score.dart';

class ScoreBoard extends StatefulWidget {
  static const routeName = '/scoreboard-screen';

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Tasks>(context, listen: false).setScoreBoard();

      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Tasks tasks = Provider.of<Tasks>(context);
    Map<String, int> score = tasks.scoreboard;
    print(score);
    score.forEach((name, score) {
      print('name $name score $score \n');
    });
    List<Score> scoreList = [];
    score.forEach((name, score) {
      final userScore = Score(name, score);
      int i = 0;
      while (i < scoreList.length) {
        if (scoreList[i].compareTo(userScore) == -1) {
          break;
        }
        i++;
      }
      scoreList.insert(i, userScore);
    });
    scoreList.forEach((score) {
      print('name ${score.name} score ${score.points}  \n');
    });
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: const Text('Scoreboard')),
      body: ListView.builder(
          itemCount: scoreList.length,
          itemBuilder: (ctx, i) => ListTile(
                leading: Text('${i + 1} ${scoreList[i].name}'),
                trailing: Text(scoreList[i].points.toString()),
              )),
    );
  }
}
