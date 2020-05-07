import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui' as ui show Image;

import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spritewidget/spritewidget.dart';

import 'game_demo.dart';

PersistantGameState _gameState;

ImageMap _imageMap;
SpriteSheet _spriteSheet;
SpriteSheet _spriteSheetUI;

SoundAssets _sounds;

gamestart(
  userId,
  goalName,
  petHealth,
  petType,
  petName,
) async {
  // We need to call ensureInitialized if we are loading images before runApp
  // is called.
  // TODO: This should be refactored to use a loading screen
  WidgetsFlutterBinding.ensureInitialized();

  // Load game state
  _gameState = new PersistantGameState();
  await _gameState.load();

  // Load images
  _imageMap = new ImageMap(rootBundle);

  await _imageMap.load(<String>[
    'lib/game/assets/grass.png',
    'lib/game/assets/catabove.png',
    'lib/game/assets/good.png',
    'lib/game/assets/bad.png',
    'lib/game/assets/spritesheet.png',
    'lib/game/assets/game_ui.png',
  ]);

  // Load sprite sheets
  String json = await rootBundle.loadString('lib/game/assets/spritesheet.json');
  _spriteSheet =
      new SpriteSheet(_imageMap['lib/game/assets/spritesheet.png'], json);

  json = await rootBundle.loadString('lib/game/assets/game_ui.json');
  _spriteSheetUI =
      new SpriteSheet(_imageMap['lib/game/assets/game_ui.png'], json);

  assert(_spriteSheet.image != null);

  // All game assets are loaded - we are good to go!
  runApp(new GamePage(
      userId: userId,
      goalName: goalName,
      petHealth: petHealth,
      petType: petType,
      petName: petName));
}

class GamePage extends StatefulWidget {
  GamePage(
      {this.userId, this.petName, this.goalName, this.petType, this.petHealth});

  final String userId;
  final String petName;
  final String goalName;
  final String petType;
  final int petHealth;

  @override
  _GamePage createState() {
    return _GamePage(
        userId: userId,
        petName: petName,
        goalName: goalName,
        petType: petType,
        petHealth: petHealth);
  }
}

class _GamePage extends State<GamePage> {
  NodeWithSize rootNode;

  _GamePage(
      {this.userId, this.petName, this.goalName, this.petType, this.petHealth});

  final String userId;
  final String petName;
  final String goalName;
  final String petType;
  int petHealth;

  @override
  void initState() {
    super.initState();
    rootNode = new NodeWithSize(const Size(1024.0, 1024.0));
  }

  @override
  GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Title(
          title: 'GAME TIME',
          color: Colors.green,
          child: new Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/game':
                    return _buildGameSceneRoute();
                  default:
                    return _buildMainSceneRoute();
                }
              })),
    );
  }

  PageRoute _buildGameSceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      return new GameScene(
          onGameOver: (int lastScore, int coins, int levelReached) {
            setState(() {
              _gameState.lastScore = lastScore;
              _gameState.coins += coins;
              _gameState.reachedLevel(levelReached);
            });
          },
          gameState: _gameState);
    });
  }

  PageRoute _buildMainSceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      return new MainScene(
          petName: petName,
          gameState: _gameState,
          onStartLevelUp: () {
            setState(() {
              _gameState.currentStartingLevel++;
              _sounds.play('click');
            });
          },
          onStartLevelDown: () {
            setState(() {
              _gameState.currentStartingLevel--;
              _sounds.play('click');
            });
          });
    });
  }
}

class GameScene extends StatefulWidget {
  GameScene({this.onGameOver, this.gameState});

  final GameOverCallback onGameOver;
  final PersistantGameState gameState;

  State<GameScene> createState() => new GameSceneState();
}

class GameSceneState extends State<GameScene> {
  NodeWithSize _game;

  void initState() {
    super.initState();

    _game = new GameDemoNode(
        _imageMap, _spriteSheet, _spriteSheetUI, _sounds, widget.gameState,
        (int score, int coins, int levelReached) {
      Navigator.pop(context);
      widget.onGameOver(score, coins, levelReached);
    });
  }

  Widget build(BuildContext context) {
    return new SpriteWidget(_game, SpriteBoxTransformMode.fixedWidth);
  }
}

class MainScene extends StatefulWidget {
  MainScene({
    this.onStartLevelUp,
    this.onStartLevelDown,
    this.petName,
    this.gameState,
  });

  final PersistantGameState gameState;
  final VoidCallback onStartLevelUp;
  final VoidCallback onStartLevelDown;
  final String petName;

  State<MainScene> createState() => new MainSceneState(petName: petName);
}

class MainSceneState extends State<MainScene> {
  MainSceneState({this.petName});
  void initState() {
    super.initState();
  }

  final String petName;

  Widget build(BuildContext context) {
    var notchOffset = MediaQuery.of(context).padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: notchOffset,
        ),
        Expanded(
          child: CoordinateSystem(
            systemSize: Size(320.0, 320.0),
            child: DefaultTextStyle(
              style: TextStyle(fontFamily: "Pixelar", fontSize: 20.0),
              child: Stack(
                children: <Widget>[
                  MainSceneBackground(),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 320.0,
                        height: 98.0,
                        child: TopBar(
                          gameState: widget.gameState,
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        height: 93.0,
                        child: BottomBar(
                          onPlay: () {
                            Navigator.pushNamed(context, '/game');
                          },
                          onStartLevelUp: widget.onStartLevelUp,
                          onStartLevelDown: widget.onStartLevelDown,
                          gameState: widget.gameState,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopBar extends StatelessWidget {
  TopBar({
    this.selection,
    this.gameState,
  });
// this.onSelectTab,

  final int selection;
  // final SelectTabCallback onSelectTab;
  final PersistantGameState gameState;

  Widget build(BuildContext context) {
    TextStyle scoreLabelStyle = new TextStyle(
        fontFamily: "Pixelar",
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: Colors.black);

    return new Stack(children: <Widget>[
      new Positioned(
          left: 18.0,
          top: 13.0,
          child: new Text("Last Score", style: scoreLabelStyle)),
      new Positioned(
          left: 18.0,
          top: 39.0,
          child: new Text("Weekly Best", style: scoreLabelStyle)),
      new Positioned(
          right: 18.0,
          top: 13.0,
          child: new Text("${gameState.lastScore}", style: scoreLabelStyle)),
      new Positioned(
          right: 18.0,
          top: 39.0,
          child:
              new Text("${gameState.weeklyBestScore}", style: scoreLabelStyle)),
      // new Positioned(
      //     left: 18.0,
      //     top: 80.0,
      //     child: new TextureImage(
      //         texture: _spriteSheetUI['icn_crystal.png'],
      //         width: 12.0,
      //         height: 18.0)),
      new Positioned(
          left: 36.0,
          top: 81.0,
          child: new Text("${gameState.coins}",
              style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)))
    ]);
  }
}

class BottomBar extends StatelessWidget {
  BottomBar(
      {this.onPlay,
      this.gameState,
      this.onStartLevelUp,
      this.onStartLevelDown});

  final VoidCallback onPlay;
  final VoidCallback onStartLevelUp;
  final VoidCallback onStartLevelDown;
  final PersistantGameState gameState;

  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      // new Positioned(
      //     left: 18.0,
      //     top: 14.0,
      //     child: new TextureImage(
      //         texture: _spriteSheetUI['level_display.png'],
      //         width: 62.0,
      //         height: 62.0)),
      // new Positioned(
      //     left: 18.0,
      //     top: 14.0,
      //     child: new TextureImage(
      //         texture: _spriteSheetUI[
      //             'level_display_${gameState.currentStartingLevel + 1}.png'],
      //         width: 62.0,
      //         height: 62.0)),
      // new Positioned(
      //     left: 85.0,
      //     top: 14.0,
      //     child: new TextureButton(
      //         texture: _spriteSheetUI['btn_level_up.png'],
      //         width: 30.0,
      //         height: 30.0,
      //         onPressed: onStartLevelUp)),
      // new Positioned(
      //     left: 85.0,
      //     top: 46.0,
      //     child: new TextureButton(
      //         texture: _spriteSheetUI['btn_level_down.png'],
      //         width: 30.0,
      //         height: 30.0,
      //         onPressed: onStartLevelDown)),
      new Positioned(
          left: 120.0,
          top: 14.0,
          child: new TextureButton(
              onPressed: onPlay,
              texture: _spriteSheetUI['btn_play.png'],
              label: "PLAY",
              textStyle: new TextStyle(
                  fontFamily: "Press Start 2P",
                  fontSize: 28.0,
                  letterSpacing: 3.0,
                  color: Colors.yellow),
              textAlign: TextAlign.center,
              width: 181.0,
              height: 62.0))
    ]);
  }
}

class MainSceneBackground extends StatefulWidget {
  MainSceneBackgroundState createState() => new MainSceneBackgroundState();
}

class MainSceneBackgroundState extends State<MainSceneBackground> {
  MainSceneBackgroundNode _backgroundNode;

  void initState() {
    super.initState();
    _backgroundNode = new MainSceneBackgroundNode();
  }

  Widget build(BuildContext context) {
    return new SpriteWidget(_backgroundNode, SpriteBoxTransformMode.fixedWidth);
  }
}

class MainSceneBackgroundNode extends NodeWithSize {
  Sprite _bgTop;
  Sprite _bgBottom;
  RepeatedImage _background;
  RepeatedImage _nebula;

  MainSceneBackgroundNode() : super(new Size(320.0, 320.0)) {
    // assert(_spriteSheet.image != null);

    // Add background
    _background = new RepeatedImage(_imageMap['lib/game/assets/grass.png']);
    addChild(_background);

    // StarField starField = new StarField(_spriteSheet, 200, true);
    // addChild(starField);

    // Add nebula
    // _nebula = new RepeatedImage(_imageMap["assets/nebula.png"], BlendMode.plus);
    // addChild(_nebula);

    // _bgTop = new Sprite.fromImage(_imageMap["assets/ui_bg_top.png"]);
    // _bgTop.pivot = Offset.zero;
    // _bgTop.size = new Size(320.0, 108.0);
    // addChild(_bgTop);

    // _bgBottom = new Sprite.fromImage(_imageMap["assets/ui_bg_bottom.png"]);
    // _bgBottom.pivot = new Offset(0.0, 1.0);
    // _bgBottom.size = new Size(320.0, 97.0);
    // addChild(_bgBottom);
  }

  void paint(Canvas canvas) {
    canvas.drawRect(new Rect.fromLTWH(0.0, 0.0, 320.0, 320.0),
        new Paint()..color = new Color(0xff000000));
    super.paint(canvas);
  }

  void spriteBoxPerformedLayout() {
    _bgBottom.position = new Offset(0.0, spriteBox.visibleArea.size.height);
  }

  void update(double dt) {
    _background.move(10.0 * dt);
    _nebula.move(100.0 * dt);
  }
}

class LaserDisplay extends StatelessWidget {
  LaserDisplay({this.level});

  final int level;

  Widget build(BuildContext context) {
    return new IgnorePointer(
        child: new SizedBox(
            child: new SpriteWidget(new LaserDisplayNode(level)),
            width: 26.0,
            height: 26.0));
  }
}

class LaserDisplayNode extends NodeWithSize {
  LaserDisplayNode(int level) : super(new Size(16.0, 16.0)) {
    Node placementNode = new Node();
    placementNode.position = new Offset(8.0, 8.0);
    placementNode.scale = 0.7;
    addChild(placementNode);
    addLaserSprites(placementNode, level, 0.0, _spriteSheet);
  }
}
