class Flower extends Mob {

  private AnimatedImage animatedImageFlower;
  private final int FLOWERFRAMES = 4;

  PImage[]  flowerFrames = new PImage[FLOWERFRAMES];

    public Flower() {
        setupLightSource(this, 125f, 1f);
        size.set(Globals.TILE_SIZE, Globals.TILE_SIZE);

        setMaxHp(20);
        loadFrames();
    }

    private void loadFrames() {
        for (int i = 0; i < FLOWERFRAMES; i++) {
            flowerFrames[i] = ResourceManager.getImage("Flower" + i); 
        }
            animatedImageFlower = new AnimatedImage(flowerFrames, 20 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
    }

    void draw() {
		animatedImageFlower.draw();
    }

    void takeDamage(float damageTaken) {
	    super.takeDamage(damageTaken);
	    AudioManager.playSoundEffect("HurtSound", position);
	    delete(this);
	    }
    }