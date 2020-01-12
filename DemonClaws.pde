class DemonClaw extends Tile
{
    private AnimatedImage animatedImageDemonClaw;
	private final int CLAW_FRAMES = 2;
    float damage = 10;

    public DemonClaw(int x, int y)
	{

		super(x, y);

        slipperiness = 0.1;
		healthMultiplier = 5f;
		setMaxHp(100);
		size.set(TILE_SIZE, TILE_SIZE);

		animatedImageDemonClaw = new AnimatedImage("DemonClaw", CLAW_FRAMES, 20, position, size.x, false);
	}

    void collidedWith(BaseObject object)
	{
		object.takeDamage(damage);

		if(object instanceof Mob)
		{
			Mob mob = (Mob) object;

			mob.removeLight();
		}
	}

    void draw()
	{
		animatedImageDemonClaw.draw();
	}

}