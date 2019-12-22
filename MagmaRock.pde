class MagmaRock extends Tile
{
	//we want enough damage so the player won't mine trough it
	float damage = 18;

	MagmaRock(int x, int y)
	{    
		super(x, y);

		setupLightSource(this, 300, 1f);
		image = ResourceManager.getImage("LavaBlock");

		slipperiness = 0.1;
		healthMultiplier = 3f;
		setMaxHp(40);
	}

	void collidedWith(BaseObject object)
	{
		object.takeDamage(damage);

		if(object instanceof Mob)
		{
			Mob mob = (Mob) object;

			mob.setOnFire();
		}
	}
}
