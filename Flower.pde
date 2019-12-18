class Flower extends Mob {

	private AnimatedImage animatedImageFlower;
	private final int FLOWERFRAMES = 4;

	public Flower()
	{
		setupLightSource(this, 125f, 1f);
		size.set(Globals.TILE_SIZE, Globals.TILE_SIZE);

		setMaxHp(20);
		animatedImageFlower = new AnimatedImage("Flower", FLOWERFRAMES, 20, position, size.x, flipSpriteHorizontal);
	}

	void draw()
	{
		animatedImageFlower.draw();
	}

	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);
		AudioManager.playSoundEffect("HurtSound", position);
		delete(this);
	}
}