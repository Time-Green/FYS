class Dynamite extends Item
{
	int explosionSize = 400;

	Dynamite()
	{
		// not actually dynamite ssssh
		image = ResourceManager.getImage("Dynamite");
	}

	void collidedWith(BaseObject object)
	{
		// someone threw us and we hit something so its kaboom time
		if (thrower != null)
		{
			load(new Explosion(position, explosionSize, 5, false));
			delete(this);
		}
	}
}
