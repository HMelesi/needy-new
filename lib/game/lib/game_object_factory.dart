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
    // double distribution = (level * 0.2).clamp(0.0, 0.8);
    double distribution = 0.6;

    for (int i = 0; i < numBads; i++) {
      GameObject obj;

      if (randomDouble() < distribution)
        obj = new WhiteCloud(this);
      else
        obj = new GreyCloud(this);

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
    int numCoins = 3 + level * 4;

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
