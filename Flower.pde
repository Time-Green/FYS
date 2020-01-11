class Flower extends BaseObject
{
	private AnimatedImage animatedImageFlower;
	private final int FLOWER_FRAMES = 4;

	public Flower()
	{
		setupLightSource(this, 125f, 1f);
		size.set(TILE_SIZE, TILE_SIZE);

		animatedImageFlower = new AnimatedImage("Flower", FLOWER_FRAMES, 20, position, size.x, false);
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