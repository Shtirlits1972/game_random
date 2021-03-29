import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:game_random/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:game_random/gameResult.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Random',
      theme: ThemeData(fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Game Random'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<int> passedRooms = Set<int>();
  int rommsPassed = 0;
  String roomsDeskr = '';
  String route = '';

  int health = 30;
  int attempt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      image: DecorationImage(
                        image: AssetImage('assets/images/rooms.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Room passed: $rommsPassed / ${constants().rooms.length}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            reset();
                          },
                          child: Text(
                            'RESET',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'health: $health',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'attempt $attempt / ${constants().attempts}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 100,
                    child: Text(
                      roomsDeskr,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'NewTegomin'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundColor: Colors.blue,
                  child: IconButton(
                      color: Colors.black,
                      icon: Icon(Foundation.arrow_left),
                      onPressed: () {
                        pressButton('west');
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.blue,
                      child: IconButton(
                          color: Colors.black,
                          icon: Icon(Foundation.arrow_up),
                          onPressed: () {
                            pressButton('north');
                          }),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    CircleAvatar(
                      foregroundColor: Colors.blue,
                      child: IconButton(
                          color: Colors.black,
                          icon: Icon(Foundation.arrow_down),
                          onPressed: () {
                            pressButton('south');
                          }),
                    ),
                  ],
                ),
                CircleAvatar(
                  foregroundColor: Colors.blue,
                  child: IconButton(
                      color: Colors.black,
                      icon: Icon(Foundation.arrow_right),
                      onPressed: () {
                        pressButton('east');
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 100,
              color: Colors.yellow,
              child: Center(
                child: Text(
                  route,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      health = constants().health;
      attempt = 0;
      rommsPassed = 0;
      roomsDeskr = '';
      passedRooms.clear();
    });
  }

  void gameOver(bool isWin, String reason) {
    setState(() {
      if (isWin) {
        route = 'You won! reason : $reason';
      } else {
        route = 'You lose! reason : $reason';
      }
      reset();
    });
  }

  void pressButton(String message) {
    Random rnd = new Random();
    int r2 = rnd.nextInt(constants().rooms.length);

    int healthDelta = rnd.nextInt(10) - 5;

    if (!passedRooms.contains(r2)) {
      setState(() {
        passedRooms.add(r2);
        rommsPassed = passedRooms.length;
      });
    }

    passedRooms.add(r2);
    setState(() {
      health += healthDelta;
      attempt++;
      roomsDeskr = constants().rooms[r2];
      route = 'you went ' + message;

      game_result gr = checkStateGame();

      if (gr.gameOver) {
        gameOver(gr.isVon, gr.reason);
      }
    });
  }

  game_result checkStateGame() {
    String reason = '';

    if (health <= 0 || attempt >= constants().attempts) {
      if (health <= 0) {
        reason += 'health is over ';
      }

      if (attempt >= constants().attempts) {
        reason = 'attempts ended';
      }

      return game_result(gameOver: true, isVon: false, reason: reason);
    } else if (rommsPassed == constants().rooms.length) {
      reason = 'you went through all the rooms ';
      return game_result(gameOver: true, isVon: true, reason: reason);
    }
    return game_result(gameOver: false, isVon: false, reason: reason);
  }
}
