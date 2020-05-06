import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui' as ui show Image;

import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spritewidget/spritewidget.dart';

import 'game_demo.dart';

// PersistantGameState _gameState;

ImageMap _imageMap;
SpriteSheet _spriteSheet;
SpriteSheet _spriteSheetUI;

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
  // WidgetsFlutterBinding.ensureInitialized();

  // Load game state
  // _gameState = new PersistantGameState();
  // await _gameState.load();

  // Load images
  _imageMap = new ImageMap(rootBundle);

  await _imageMap.load(<String>[
    'lib/game/assets/grass.png',
  ]);

  // Load sprite sheets
  String json = await rootBundle.loadString('lib/game/assets/sprites.json');
  _spriteSheet =
      new SpriteSheet(_imageMap['lib/game/assets/sprites.png'], json);

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
      return Text('in the game scene route with $petName');
      // return new GameScene(
      //   onGameOver: (int lastScore, int coins, int levelReached) {
      //     setState(() {
      //       _gameState.lastScore = lastScore;
      //       _gameState.coins += coins;
      //       _gameState.reachedLevel(levelReached);
      //     });
      //   },
      //   gameState: _gameState
      // );
    });
  }

  PageRoute _buildMainSceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      return new MainScene(petName: petName);
      // gameState: _gameState,
      //   onUpgradePowerUp: (PowerUpType type) {
      //     setState(() {
      //       if (_gameState.upgradePowerUp(type))
      //         _sounds.play('buy_upgrade');
      //       else
      //         _sounds.play('click');
      //     });
      //   },
      //   onUpgradeLaser: () {
      //     setState(() {
      //       if (_gameState.upgradeLaser())
      //         _sounds.play('buy_upgrade');
      //       else
      //         _sounds.play('click');
      //     });
      //   },
      //   onStartLevelUp: () {
      //     setState(() {
      //       _gameState.currentStartingLevel++;
      //       _sounds.play('click');
      //     });
      //   },
      //   onStartLevelDown: () {
      //     setState(() {
      //       _gameState.currentStartingLevel--;
      //       _sounds.play('click');
      //     });
      //   }
      // );
    });
  }
}

class GameScene extends StatefulWidget {
  // GameScene({this.onGameOver, this.gameState});

  // final GameOverCallback onGameOver;
  // final PersistantGameState gameState;

  State<GameScene> createState() => new GameSceneState();
}

class GameSceneState extends State<GameScene> {
  NodeWithSize _game;

  void initState() {
    super.initState();

    // _game = new GameDemoNode(
    //     _imageMap, _spriteSheet, _spriteSheetUI, widget.gameState,
    //     (int score, int coins, int levelReached) {
    //   Navigator.pop(context);
    //   widget.onGameOver(score, coins, levelReached);
    // });
  }

  Widget build(BuildContext context) {
    return new SpriteWidget(_game, SpriteBoxTransformMode.fixedWidth);
  }
}

class MainScene extends StatefulWidget {
  MainScene(
      {this.onUpgradeLaser,
      this.onStartLevelUp,
      this.onStartLevelDown,
      this.petName});

  // this.gameState,
  // this.onUpgradePowerUp,

  // final PersistantGameState gameState;
  // final UpgradePowerUpCallback onUpgradePowerUp;
  final VoidCallback onUpgradeLaser;
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
                  // Column(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 320.0,
                  //       height: 98.0,
                  //       child: TopBar(
                  //         gameState: widget.gameState,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: CenterArea(
                  //         onUpgradeLaser: widget.onUpgradeLaser,
                  //         onUpgradePowerUp: widget.onUpgradePowerUp,
                  //         gameState: widget.gameState,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 320.0,
                  //       height: 93.0,
                  //       child: BottomBar(
                  //         onPlay: () {
                  //           Navigator.pushNamed(context, '/game');
                  //         },
                  //         onStartLevelUp: widget.onStartLevelUp,
                  //         onStartLevelDown: widget.onStartLevelDown,
                  //         gameState: widget.gameState,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class TopBar extends StatelessWidget {
//   TopBar({this.selection, this.onSelectTab, this.gameState});

//   final int selection;
//   final SelectTabCallback onSelectTab;
//   final PersistantGameState gameState;

//   Widget build(BuildContext context) {

//     TextStyle scoreLabelStyle = new TextStyle(
//       fontFamily: "Orbitron",
//       fontSize: 20.0,
//       fontWeight: FontWeight.w500,
//       color: _darkTextColor
//     );

//     return new Stack(
//       children: <Widget>[
//         new Positioned(
//           left: 18.0,
//           top: 13.0,
//           child: new Text(
//             "Last Score",
//             style: scoreLabelStyle
//           )
//         ),
//         new Positioned(
//           left: 18.0,
//           top: 39.0,
//           child: new Text(
//             "Weekly Best",
//             style: scoreLabelStyle
//           )
//         ),
//         new Positioned(
//           right: 18.0,
//           top: 13.0,
//           child: new Text(
//             "${gameState.lastScore}",
//             style: scoreLabelStyle
//           )
//         ),
//         new Positioned(
//           right: 18.0,
//           top: 39.0,
//           child: new Text(
//             "${gameState.weeklyBestScore}",
//             style: scoreLabelStyle
//           )
//         ),
//         new Positioned(
//           left: 18.0,
//           top: 80.0,
//           child: new TextureImage(
//             texture: _spriteSheetUI['icn_crystal.png'],
//             width: 12.0,
//             height: 18.0
//           )
//         ),
//         new Positioned(
//           left: 36.0,
//           top: 81.0,
//           child: new Text(
//             "${gameState.coins}",
//             style: new TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.w500,
//               color: _darkTextColor
//             )
//           )
//         )
//       ]
//     );
//   }
// }

// class CenterArea extends StatelessWidget {
//   CenterArea({
//     this.selection,
//     this.onUpgradeLaser,
//     this.gameState,
//     this.onUpgradePowerUp
//   });

//   final int selection;
//   final VoidCallback onUpgradeLaser;
//   final UpgradePowerUpCallback onUpgradePowerUp;
//   final PersistantGameState gameState;

//   Widget build(BuildContext context) {
//     return _buildCenterArea();
//   }

//   Widget _buildCenterArea() {
//     return _buildUpgradePanel();
//   }

//   Widget _buildUpgradePanel() {
//     return new Column(
//       children: <Widget>[
//         new Text("Upgrade Laser"),
//         _buildLaserUpgradeButton(),
//         new Text("Upgrade Power-Ups"),
//         new Row(
//           children: <Widget>[
//             _buildPowerUpButton(PowerUpType.shield),
//             _buildPowerUpButton(PowerUpType.sideLaser),
//             _buildPowerUpButton(PowerUpType.speedBoost),
//             _buildPowerUpButton(PowerUpType.speedLaser),
//           ],
//         mainAxisAlignment: MainAxisAlignment.center)
//       ],
//       mainAxisAlignment: MainAxisAlignment.center,
//       key: new Key("upgradePanel")
//     );
//   }

//   Widget _buildPowerUpButton(PowerUpType type) {
//     return new Padding(
//       padding: new EdgeInsets.all(8.0),
//       child: new Column(
//         children: <Widget>[
//         new TextureButton(
//           texture: _spriteSheetUI['btn_powerup_${type.index}.png'],
//           width: 57.0,
//           height: 57.0,
//           label: "${gameState.powerUpUpgradePrice(type)}",
//           labelOffset: new Offset(3.0, 18.5),
//           textStyle: new TextStyle(
//             fontFamily: "Orbitron",
//             fontSize: 11.0,
//             color: _darkTextColor
//           ),
//           textAlign: TextAlign.center,
//           onPressed: () => onUpgradePowerUp(type)
//         ),
//         new Padding(
//           padding: new EdgeInsets.all(5.0),
//           child: new Text(
//             "Lvl ${gameState.powerupLevel(type) + 1}",
//             style: new TextStyle(fontSize: 12.0)
//           )
//         )
//       ])
//     );
//   }

//   Widget _buildLaserUpgradeButton() {
//     return new Padding(
//       padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 18.0),
//       child: new Stack(
//         children: <Widget>[
//           new TextureButton(
//             texture: _spriteSheetUI['btn_laser_upgrade.png'],
//             width: 137.0,
//             height: 63.0,
//             label: "${gameState.laserUpgradePrice()}",
//             labelOffset: new Offset(2.0, 18.0),
//             textStyle: new TextStyle(
//               fontFamily: "Orbitron",
//               fontSize: 12.0,
//               color: _darkTextColor
//             ),
//             textAlign: TextAlign.center,
//             onPressed: onUpgradeLaser
//           ),
//           new Positioned(
//             child: new LaserDisplay(level: gameState.laserLevel),
//             left: 19.5,
//             top: 14.0
//           ),
//           new Positioned(
//             child: new LaserDisplay(level: gameState.laserLevel + 1),
//             right: 19.5,
//             top: 14.0
//           )
//         ]
//       )
//     );
//   }
// }

// class BottomBar extends StatelessWidget {
//   BottomBar({this.onPlay, this.gameState, this.onStartLevelUp, this.onStartLevelDown});

//   final VoidCallback onPlay;
//   final VoidCallback onStartLevelUp;
//   final VoidCallback onStartLevelDown;
//   final PersistantGameState gameState;

//   Widget build(BuildContext context) {
//     return new Stack(
//       children: <Widget>[
//         new Positioned(
//           left: 18.0,
//           top: 14.0,
//           child: new TextureImage(
//             texture: _spriteSheetUI['level_display.png'],
//             width: 62.0,
//             height: 62.0
//           )
//         ),
//         new Positioned(
//           left: 18.0,
//           top: 14.0,
//           child: new TextureImage(
//             texture: _spriteSheetUI['level_display_${gameState.currentStartingLevel + 1}.png'],
//             width: 62.0,
//             height: 62.0
//           )
//         ),
//         new Positioned(
//           left: 85.0,
//           top: 14.0,
//           child: new TextureButton(
//             texture: _spriteSheetUI['btn_level_up.png'],
//             width: 30.0,
//             height: 30.0,
//             onPressed: onStartLevelUp
//           )
//         ),
//         new Positioned(
//           left: 85.0,
//           top: 46.0,
//           child: new TextureButton(
//             texture: _spriteSheetUI['btn_level_down.png'],
//             width: 30.0,
//             height: 30.0,
//             onPressed: onStartLevelDown
//           )
//         ),
//         new Positioned(
//           left: 120.0,
//           top: 14.0,
//           child: new TextureButton(
//             onPressed: onPlay,
//             texture: _spriteSheetUI['btn_play.png'],
//             label: "PLAY",
//             textStyle: new TextStyle(fontFamily: "Orbitron", fontSize: 28.0, letterSpacing: 3.0),
//             textAlign: TextAlign.center,
//             width: 181.0,
//             height: 62.0
//           )
//         )
//       ]
//     );
//   }
// }

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
    assert(_spriteSheet.image != null);

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

// class LaserDisplay extends StatelessWidget {
//   LaserDisplay({this.level});

//   final int level;

//   Widget build(BuildContext context) {
//     return new IgnorePointer(
//       child: new SizedBox(
//         child: new SpriteWidget(new LaserDisplayNode(level)),
//         width: 26.0,
//         height: 26.0
//       )
//     );
//   }
// }

// class LaserDisplayNode extends NodeWithSize {
//   LaserDisplayNode(int level): super(new Size(16.0, 16.0)) {
//     Node placementNode = new Node();
//     placementNode.position = new Offset(8.0, 8.0);
//     placementNode.scale = 0.7;
//     addChild(placementNode);
//     addLaserSprites(placementNode, level, 0.0, _spriteSheet);
//   }
// }
