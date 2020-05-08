part of game;

const int _maxLevel = 9;

class GameObjectFactory {
  GameObjectFactory(this.sheet, this.sounds, this.level, this.playerState);

  SpriteSheet sheet;
  SoundAssets sounds;
  Level level;
  PlayerState playerState;

  void addBads(int level, double yPos) {
    int numBads = 10 + level * 4;
    double distribution = (level * 0.2).clamp(0.0, 0.8);

    for (int i = 0; i < numBads; i++) {
      GameObject obj;

      if (randomDouble() < distribution)
        obj = new Molehill(this);
      else
        obj = new Rock(this);

      Offset pos = new Offset(
          randomSignedDouble() * 160.0, yPos + _chunkSpacing * randomDouble());
      addGameObject(obj, pos);
    }
  }

  void addHeart(int level, double yPos) {
    int numHearts = 1;
    double distribution = (level * 0.2).clamp(0.0, 0.8);

    for (int i = 0; i < numHearts; i++) {
      GameObject obj;

      if (randomDouble() < distribution)
        obj = new Medi(this);
      else
        obj = new Medi(this);

      Offset pos = new Offset(
          randomSignedDouble() * 160.0, yPos + _chunkSpacing * randomDouble());
      addGameObject(obj, pos);
    }
  }

  void addCoins(int level, double yPos) {
    int numCoins = 10 + level * 4;

    // double distribution = (level * 0.4).clamp(0.0, 0.8);

    for (int i = 0; i < numCoins; i++) {
      GameObject obj;
      if (i < numCoins / 5)
        obj = new GoldCoin(this);
      else if (i < numCoins / 2 && i >= numCoins / 5)
        obj = new SilverCoin(this);
      else
        obj = new BronzeCoin(this);

      Offset pos = new Offset(
          randomSignedDouble() * 160.0, yPos + _chunkSpacing * randomDouble());
      addGameObject(obj, pos);
    }
  }

  void addGameObject(GameObject obj, Offset pos) {
    obj.position = pos;
    obj.setupActions();

    level.addChild(obj);
  }
}

final List<Color> laserColors = <Color>[
  new Color(0xff95f4fb),
  new Color(0xff5bff35),
  new Color(0xffff886c),
  new Color(0xffffd012),
  new Color(0xfffd7fff)
];

void addLaserSprites(Node node, int level, double r, SpriteSheet sheet) {
  int numLasers = level % 3 + 1;
  Color laserColor = laserColors[(level ~/ 3) % laserColors.length];

  // Add sprites
  List<Sprite> sprites = <Sprite>[];
  for (int i = 0; i < numLasers; i++) {
    Sprite sprite = new Sprite(sheet["explosion_particle.png"]);
    sprite.scale = 0.5;
    sprite.colorOverlay = laserColor;
    sprite.transferMode = ui.BlendMode.plus;
    node.addChild(sprite);
    sprites.add(sprite);
  }

  // Position the individual sprites
  if (numLasers == 2) {
    sprites[0].position = new Offset(-3.0, 0.0);
    sprites[1].position = new Offset(3.0, 0.0);
  } else if (numLasers == 3) {
    sprites[0].position = new Offset(-4.0, 0.0);
    sprites[1].position = new Offset(4.0, 0.0);
    sprites[2].position = new Offset(0.0, -2.0);
  }
}
