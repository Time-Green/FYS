class Icicle extends Obstacle
{
	private float damage = 10f;
	private int radiusX = 1;
	private int radiusY = 10;
	private String shatterNoise = "GlassBreak" + floor(random(1, 4));

	Icicle()
	{
		anchored = true;
		
		image = ResourceManager.getImage("Icicle");
	}

	void collidedWith(BaseObject object)
	{
		// we're beneath
		if(object.position.y > position.y)
		{
			object.takeDamage(damage);
			shatter();
		}
	}

	void shatter()
	{
		AudioManager.playSoundEffect(shatterNoise);

		delete(this);
	}

	void unroot(Tile tile)
	{
		anchored = false;
	}

	void update()
	{
		super.update();

		if(player.position.x < position.x + size.x && player.position.x > position.x)
		{
			if(player.position.y > position.y)
			{
				anchored = false;
			}
		}
	}
}