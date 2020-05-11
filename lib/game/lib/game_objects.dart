part of game;

abstract class GameObject extends Node {
  GameObject(this.f);

  double radius = 0.0;
  double removeLimit = 1280.0;
  bool canDamageAnimal = false;
  bool canBeDamaged = false;
  bool canBeCollected = false;
  double maxDamage = 3.0;
  double damage = 0.0;

  final GameObjectFactory f;

  Paint _paintDebug = new Paint()
    ..color = new Color(0xffff0000)
    ..strokeWidth = 1.0
    ..style = ui.PaintingStyle.stroke;

  bool collidingWith(GameObject obj) {
    return (GameMath.distanceBetweenPoints(position, obj.position) <
        radius + obj.radius);
  }

  void move() {}

  void removeIfOffscreen(double scroll) {
    if (-position.dy > scroll + removeLimit || -position.dy < scroll - 50.0) {
      removeFromParent();
    }
  }

  void collect() {
    removeFromParent();
  }

  void losePoints(num) {
    f.playerState.score -= num;
  }

  void addDamage(double d) {
    if (!canBeDamaged) return;

    damage += d;
    if (damage >= maxDamage) {
      // destroy();
      f.playerState.score += (maxDamage * 10).ceil();
    } else {
      // f.sounds.play("hit");
    }
  }

  void paint(Canvas canvas) {
    if (_drawDebug) {
      canvas.drawCircle(Offset.zero, radius, _paintDebug);
    }
    super.paint(canvas);
  }

  void setupActions() {}
}

class LevelLabel extends GameObject {
  LevelLabel(GameObjectFactory f, int level) : super(f) {
    Label lbl = new Label("LEVEL $level",
        textAlign: TextAlign.center,
        textStyle: new TextStyle(
            fontFamily: "PressStart2P",
            letterSpacing: 0.0,
            color: new Color(0xFFEE91E63),
            fontSize: 24.0,
            fontWeight: FontWeight.w600));
    addChild(lbl);
  }
}

class Animal extends GameObject {
  bool canDamageAnimal = false;
  bool canBeDamaged = false;
  bool canBeCollected = false;

  Animal(GameObjectFactory f) : super(f) {
    // Add main animal sprite
    _sprite = new Sprite(f.sheet["catfly_1.png"]);
    _sprite.scale = 0.9;
    _sprite.rotation = 0.0;
    addChild(_sprite);

    // Set start position
    position = new Offset(0.0, 50.0);
  }

  Sprite _sprite;
  Sprite _spriteShield;

  void applyThrust(Offset joystickValue, double scroll) {
    Offset oldPos = position;
    Offset target = new Offset(
        joystickValue.dx * 160.0, joystickValue.dy * 220.0 - 250.0 - scroll);
    double filterFactor = 0.2;

    position = new Offset(GameMath.filter(oldPos.dx, target.dx, filterFactor),
        GameMath.filter(oldPos.dy, target.dy, filterFactor));
  }
}

Color colorForDamage(double damage, double maxDamage, [Color toColor]) {
  int r, g, b;
  if (toColor == null) {
    r = 255;
    g = 3;
    b = 86;
  } else {
    r = toColor.red;
    g = toColor.green;
    b = toColor.blue;
  }

  int alpha = ((200.0 * damage) ~/ maxDamage).clamp(0, 200);
  return new Color.fromARGB(alpha, r, g, b);
}

abstract class Obstacle extends GameObject {
  Obstacle(GameObjectFactory f) : super(f);

  bool canDamageAnimal = true;
  bool canBeCollected = false;
  double explosionScale = 1.0;

  // Explosion createExplosion() {
  //   f.sounds.play("explosion_${randomInt(3)}");
  //   Explosion explo = new ExplosionBig(f.sheet);
  //   explo.scale = explosionScale;
  //   return explo;
  // }
}

abstract class Bad extends Obstacle {
  Bad(GameObjectFactory f) : super(f);

  bool canDamageAnimal = true;
  bool canBeCollected = false;
  double explosionScale = 1.0;
  Sprite _sprite;

  void setupActions() {
    MotionTween fadeIn = new MotionTween<double>((a) {
      _sprite.opacity = a;
    }, 0.0, 1.0, 8);
    motions.run(fadeIn);
  }

  set damage(double d) {
    super.damage = d;
    _sprite.colorOverlay = colorForDamage(d, maxDamage);
  }
}

class GreyCloud extends Bad {
  GreyCloud(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["cloud_grey.png"]);
    _sprite.scale = 0.8;
    radius = 30.0;
    addChild(_sprite);
  }
}

class WhiteCloud extends Bad {
  WhiteCloud(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["cloud_white.png"]);
    _sprite.scale = 0.8;
    radius = 30.0;
    addChild(_sprite);
  }
}

class Collectable extends GameObject {
  Collectable(GameObjectFactory f) : super(f) {
    canDamageAnimal = false;
    canBeDamaged = false;
    canBeCollected = true;

    zPosition = 20.0;
  }
}

class Medi extends Collectable {
  Medi(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["medi.png"]);
    _sprite.scale = 1;
    radius = 40.0;
    addChild(_sprite);
  }

  Sprite _sprite;

  void collect() {
    // f.sounds.play("pickup_0");
    f.playerState.score += 50;
    super.collect();
  }
}

class GoldCoin extends Collectable {
  GoldCoin(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["coin_gold.png"]);
    _sprite.scale = 0.5;
    radius = 10;
    addChild(_sprite);
  }

  void setupActions() {
    // Rotate
    // MotionTween rotate = new MotionTween<double>((a) {
    //   _sprite.rotation = a;
    // }, 0.0, 360.0, 5.0);
    // motions.run(new MotionRepeatForever(rotate));

    // Fade in
    MotionTween fadeIn = new MotionTween<double>((a) {
      _sprite.opacity = a;
    }, 0.0, 1.0, 0.6);
    motions.run(fadeIn);
  }

  Sprite _sprite;

  void collect() {
    // f.sounds.play("pickup_0");
    f.playerState.addGoldCoin(this);
    super.collect();
  }
}

class SilverCoin extends Collectable {
  SilverCoin(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["coin_silver.png"]);
    _sprite.scale = 0.5;
    radius = 10;
    addChild(_sprite);
  }

  void setupActions() {
    // Rotate
    // MotionTween rotate = new MotionTween<double>((a) {
    //   _sprite.rotation = a;
    // }, 0.0, 360.0, 5.0);
    // motions.run(new MotionRepeatForever(rotate));

    // Fade in
    MotionTween fadeIn = new MotionTween<double>((a) {
      _sprite.opacity = a;
    }, 0.0, 1.0, 0.6);
    motions.run(fadeIn);
  }

  Sprite _sprite;

  void collect() {
    // f.sounds.play("pickup_0");
    f.playerState.addSilverCoin(this);
    super.collect();
  }
}

class BronzeCoin extends Collectable {
  BronzeCoin(GameObjectFactory f) : super(f) {
    _sprite = new Sprite(f.sheet["coin_bronze.png"]);
    _sprite.scale = 0.5;
    radius = 10;
    addChild(_sprite);
  }

  void setupActions() {
    // Rotate
    // MotionTween rotate = new MotionTween<double>((a) {
    //   _sprite.rotation = a;
    // }, 0.0, 360.0, 5.0);
    // motions.run(new MotionRepeatForever(rotate));

    // Fade in
    MotionTween fadeIn = new MotionTween<double>((a) {
      _sprite.opacity = a;
    }, 0.0, 1.0, 0.6);
    motions.run(fadeIn);
  }

  Sprite _sprite;

  void collect() {
    // f.sounds.play("pickup_0");
    f.playerState.addBronzeCoin(this);
    super.collect();
  }
}
