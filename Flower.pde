class Flower extends Mob {

  private AnimatedImage animatedImageFlower;
  private final int FLOWERFRAMES = 4;

  PImage[]  flowerFrames = new PImage[FLOWERFRAMES];

    public Flower() {
        this.position = new PVector(1395, 509);
        setupLightSource(this, 125f, 1f);
        setMaxHp(20);
        loadFrames();
        //image = ResourceManager.getImage("Flower" + 0); 
    }

    private void loadFrames() {
        for (int i = 0; i < FLOWERFRAMES; i++) {
            flowerFrames[i] = ResourceManager.getImage("Flower" + i); 
        }
            animatedImageFlower = new AnimatedImage(flowerFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
    }

    void update() {
        super.update();

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