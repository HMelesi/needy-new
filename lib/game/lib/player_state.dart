part of game;

class PlayerState extends Node {
  PlayerState(this._sheetUI, this._sheetGame, this._gameState) {
    // Score display
    _spriteBackgroundScore = new Sprite(_sheetUI["btn_play.png"]);
    _spriteBackgroundScore.pivot = new Offset(1.0, 0.0);
    _spriteBackgroundScore.scale = 0.35;
    _spriteBackgroundScore.position = new Offset(240.0, 10.0);
    addChild(_spriteBackgroundScore);

    _scoreDisplay = new ScoreDisplay(_sheetUI);
    _scoreDisplay.position = new Offset(349.0, 49.0);
    _spriteBackgroundScore.addChild(_scoreDisplay);

    // Coin display
    _spriteBackgroundCoins = new Sprite(_sheetUI["btn_exit.png"]);
    _spriteBackgroundCoins.pivot = new Offset(1.0, 0.0);
    _spriteBackgroundCoins.scale = 0.35;
    _spriteBackgroundCoins.position = new Offset(105.0, 10.0);
    addChild(_spriteBackgroundCoins);

    _coinDisplay = new ScoreDisplay(_sheetUI);
    _coinDisplay.position = new Offset(252.0, 49.0);
    _spriteBackgroundCoins.addChild(_coinDisplay);

    laserLevel = _gameState.laserLevel;
  }

  final SpriteSheet _sheetUI;
  final SpriteSheet _sheetGame;
  final PersistantGameState _gameState;

  int laserLevel = 0;

  static const double normalScrollSpeed = 2.0;

  double scrollSpeed = normalScrollSpeed;

  double _scrollSpeedTarget = normalScrollSpeed;

  Sprite _spriteBackgroundScore;
  ScoreDisplay _scoreDisplay;
  Sprite _spriteBackgroundCoins;
  ScoreDisplay _coinDisplay;

  int get score => _scoreDisplay.score;

  set score(int score) {
    _scoreDisplay.score = score;
    flashBackgroundSprite(_spriteBackgroundScore);
  }

  int get coins => _coinDisplay.score;

  void addGoldCoin(GoldCoin c) {
    // Animate coin to the top of the screen
    Offset startPos = convertPointFromNode(Offset.zero, c);
    Offset finalPos = new Offset(30.0, 30.0);
    Offset middlePos = new Offset((startPos.dx + finalPos.dx) / 2.0 + 50.0,
        (startPos.dy + finalPos.dy) / 2.0);

    List<Offset> path = <Offset>[startPos, middlePos, finalPos];

    Sprite sprite = new Sprite(_sheetGame["coin_gold.png"]);
    sprite.scale = 0.7;

    MotionSpline spline = new MotionSpline((Offset a) {
      sprite.position = a;
    }, path, 0.5);
    spline.tension = 0.25;
    MotionTween rotate = new MotionTween<double>((a) {
      sprite.rotation = a;
    }, 0.0, 360.0, 0.5);
    MotionTween scale = new MotionTween<double>((a) {
      sprite.scale = a;
    }, 0.7, 1.2, 0.5);
    MotionGroup group = new MotionGroup(<Motion>[spline, rotate, scale]);
    sprite.motions.run(new MotionSequence(<Motion>[
      group,
      new MotionRemoveNode(sprite),
      new MotionCallFunction(() {
        _coinDisplay.score += 5;
        flashBackgroundSprite(_spriteBackgroundCoins);
      })
    ]));
    print(_coinDisplay.score);
    addChild(sprite);
  }

  void addSilverCoin(SilverCoin c) {
    // Animate coin to the top of the screen
    Offset startPos = convertPointFromNode(Offset.zero, c);
    Offset finalPos = new Offset(30.0, 30.0);
    Offset middlePos = new Offset((startPos.dx + finalPos.dx) / 2.0 + 50.0,
        (startPos.dy + finalPos.dy) / 2.0);

    List<Offset> path = <Offset>[startPos, middlePos, finalPos];

    Sprite sprite = new Sprite(_sheetGame["coin_silver.png"]);
    sprite.scale = 0.7;

    MotionSpline spline = new MotionSpline((Offset a) {
      sprite.position = a;
    }, path, 0.5);
    spline.tension = 0.25;
    MotionTween rotate = new MotionTween<double>((a) {
      sprite.rotation = a;
    }, 0.0, 360.0, 0.5);
    MotionTween scale = new MotionTween<double>((a) {
      sprite.scale = a;
    }, 0.7, 1.2, 0.5);
    MotionGroup group = new MotionGroup(<Motion>[spline, rotate, scale]);
    sprite.motions.run(new MotionSequence(<Motion>[
      group,
      new MotionRemoveNode(sprite),
      new MotionCallFunction(() {
        _coinDisplay.score += 3;
        flashBackgroundSprite(_spriteBackgroundCoins);
      })
    ]));
    print(_coinDisplay.score);
    addChild(sprite);
  }

  void addBronzeCoin(BronzeCoin c) {
    // Animate coin to the top of the screen
    Offset startPos = convertPointFromNode(Offset.zero, c);
    Offset finalPos = new Offset(30.0, 30.0);
    Offset middlePos = new Offset((startPos.dx + finalPos.dx) / 2.0 + 50.0,
        (startPos.dy + finalPos.dy) / 2.0);

    List<Offset> path = <Offset>[startPos, middlePos, finalPos];

    Sprite sprite = new Sprite(_sheetGame["coin_bronze.png"]);
    sprite.scale = 0.7;

    MotionSpline spline = new MotionSpline((Offset a) {
      sprite.position = a;
    }, path, 0.5);
    spline.tension = 0.25;
    MotionTween rotate = new MotionTween<double>((a) {
      sprite.rotation = a;
    }, 0.0, 360.0, 0.5);
    MotionTween scale = new MotionTween<double>((a) {
      sprite.scale = a;
    }, 0.7, 1.2, 0.5);
    MotionGroup group = new MotionGroup(<Motion>[spline, rotate, scale]);
    sprite.motions.run(new MotionSequence(<Motion>[
      group,
      new MotionRemoveNode(sprite),
      new MotionCallFunction(() {
        _coinDisplay.score += 1;
        flashBackgroundSprite(_spriteBackgroundCoins);
      })
    ]));
    print(_coinDisplay.score);
    addChild(sprite);
  }

  void flashBackgroundSprite(Sprite sprite) {
    sprite.motions.stopAll();
    MotionTween flash = new MotionTween<Color>((a) {
      sprite.colorOverlay = a;
    }, new Color(0x66ccfff0), new Color(0x00ccfff0), 0.3);
    sprite.motions.run(flash);
  }
}

class ScoreDisplay extends Node {
  ScoreDisplay(this._sheetUI);

  int _score = 0;

  int get score => _score;

  set score(int score) {
    _score = score;
    _dirtyScore = true;
  }

  SpriteSheet _sheetUI;

  bool _dirtyScore = true;

  void update(double dt) {
    if (_dirtyScore) {
      removeAllChildren();
      print(_score);
      // String scoreStr = _score.toString();
      // double xPos = -37.0;
      // for (int i = scoreStr.length - 1; i >= 0; i--) {
      //   String numStr = scoreStr.substring(i, i + 1);
      //   Sprite numSprite = new Sprite(_sheetUI["number_$numStr.png"]);
      //   numSprite.position = new Offset(xPos, 0.0);
      //   addChild(numSprite);
      //   xPos -= 37.0;
      // }
      _dirtyScore = false;
    }
  }
}
