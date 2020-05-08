part of game;

final double _gameSizeWidth = 320.0;
double _gameSizeHeight = 320.0;

final double _chunkSpacing = 640.0;
final int _chunksPerLevel = 9;

final bool _drawDebug = false;

typedef void GameOverCallback(int score, int coins, int levelReached);

class GameDemoNode extends NodeWithSize {
  GameDemoNode(this._images, this._spritesGame, this._spritesUI, this._sounds,
      this._gameState, petHealth, this._gameOverCallback)
      : super(new Size(320.0, 320.0)) {
    // Add background
    _background = new RepeatedImage(_images["lib/game/assets/grass.png"]);
    addChild(_background);

    // Setup game screen, it will always be anchored to the bottom of the screen
    _gameScreen = new Node();
    addChild(_gameScreen);

    // Setup the level and add it to the screen, the level is the node where
    // all our game objects live. It is moved to scroll the game
    _level = new Level();
    _gameScreen.addChild(_level);

    // Add heads up display
    _playerState = new PlayerState(_spritesUI, _spritesGame, _gameState);
    _playerState.position = Offset(0.0, 20.0);
    _playerState.score = petHealth * 10;
    addChild(_playerState);

    _objectFactory =
        new GameObjectFactory(_spritesGame, _sounds, _level, _playerState);

    _level.ship = new Ship(_objectFactory);
    _level.ship.setupActions();
    _level.addChild(_level.ship);

    // Add the joystick
    _joystick = new VirtualJoystick();
    _gameScreen.addChild(_joystick);

    // Add initial game objects
    addObjects();
  }

  final PersistantGameState _gameState;

  // Resources
  ImageMap _images;
  SoundAssets _sounds;
  SpriteSheet _spritesGame;
  SpriteSheet _spritesUI;

  // Callback
  GameOverCallback _gameOverCallback;

  // Game screen nodes
  Node _gameScreen;
  VirtualJoystick _joystick;

  GameObjectFactory _objectFactory;
  Level _level;
  int _topLevelReached = 0;
  RepeatedImage _background;
  PlayerState _playerState;

  // Game properties
  double _scroll = 0.0;

  int _framesToFire = 0;
  int _framesBetweenShots = 20;

  bool _gameOver = false;

  void spriteBoxPerformedLayout() {
    _gameSizeHeight = spriteBox.visibleArea.height;
    _gameScreen.position = new Offset(0.0, _gameSizeHeight);
  }

  void update(double dt) {
    // Scroll the level
    _scroll = _level.scroll(_playerState.scrollSpeed);
    // _starField.move(0.0, _playerState.scrollSpeed);

    _background.move(_playerState.scrollSpeed * 0.2);
    // _nebula.move(_playerState.scrollSpeed);

    // Add objects
    addObjects();

    // Move the ship
    if (!_gameOver) {
      _level.ship.applyThrust(_joystick.value, _scroll);
    }

    // Move game objects
    for (Node node in _level.children) {
      if (node is GameObject) {
        node.move();
      }
    }

    // Remove offscreen game objects
    for (int i = _level.children.length - 1; i >= 0; i--) {
      Node node = _level.children[i];
      if (node is GameObject) {
        node.removeIfOffscreen(_scroll);
      }
    }

    if (_gameOver) return;

    // Check for collsions between ship and objects that can damage the ship
    List<Node> nodes = new List<Node>.from(_level.children);
    for (Node node in nodes) {
      if (node is GameObject && node.canDamageShip) {
        if (node.collidingWith(_level.ship) && node is Bad) {
          hitCatBad();
        }
        // else if (node.collidingWith(_level.ship) && node is HeartLove) {
        //   hitHeart();
        // }
      } else if (node is GameObject && node.canBeCollected) {
        if (node.collidingWith(_level.ship)) {
          // The ship ran over something collectable
          node.collect();
        }
      }
    }
  }

  int _chunk = 0;

  void addObjects() {
    while (_scroll + _chunkSpacing >= _chunk * _chunkSpacing) {
      addLevelChunk(_chunk, -_chunk * _chunkSpacing - _chunkSpacing);

      _chunk += 1;
    }
  }

  void addLevelChunk(int chunk, double yPos) {
    int level = chunk ~/ _chunksPerLevel + _gameState.currentStartingLevel;
    int part = chunk % _chunksPerLevel;

    if (part == 0) {
      LevelLabel lbl = new LevelLabel(_objectFactory, level + 1);
      lbl.position = new Offset(0.0, yPos + _chunkSpacing / 2.0 - 150.0);

      _topLevelReached = level;
      _level.addChild(lbl);
    } else if (part == 1) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
    } else if (part == 2) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
      _objectFactory.addHeart(level, yPos);
    } else if (part == 3) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
    } else if (part == 4) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
      _objectFactory.addHeart(level, yPos);
    } else if (part == 5) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
    } else if (part == 6) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
      _objectFactory.addHeart(level, yPos);
    } else if (part == 7) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
    } else if (part == 8) {
      _objectFactory.addBads(level, yPos);
      _objectFactory.addCoins(level, yPos);
      _objectFactory.addHeart(level, yPos);
    }
  }

  void hitCatBad() {
    _playerState.score -= 5;

    if (_playerState.score <= 0) {
      _level.ship.visible = false;

      Flash flash = new Flash(size, 1.0);
      addChild(flash);
      _gameOver = true;

      new Timer(new Duration(seconds: 2), () {
        _gameOverCallback(
            _playerState.score, _playerState.coins, _topLevelReached);
      });
    }

    print('cat was hit');
    print(_playerState.score);

    // Hide ship
    // _level.ship.visible = false;

    // _sounds.play("explosion_player");

    // Add explosion
    // ExplosionBig explo = new ExplosionBig(_spritesGame);
    // explo.scale = 1.5;
    // explo.position = _level.ship.position;
    // _level.addChild(explo);

    // Add flash
    // Flash flash = new Flash(size, 1.0);
    // addChild(flash);

    // Set the state to game over
    // _gameOver = true;

    // Return to main scene and report the score back in 2 seconds
    // new Timer(new Duration(seconds: 2), () {
    //   _gameOverCallback(
    //       _playerState.score, _playerState.coins, _topLevelReached);
    // });
  }

  // void hitHeart() {
  //   _playerState.score += 50;

  //   print('cat got a heart <3');
  //   print(_playerState.score);
  // }
}

class Level extends Node {
  Level() {
    position = new Offset(160.0, 0.0);
  }

  Ship ship;

  double scroll(double scrollSpeed) {
    position += new Offset(0.0, scrollSpeed);
    return position.dy;
  }
}