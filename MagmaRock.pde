class MagmaRock extends Tile
{
	float damage = 14;

	float particleVelocity = -3;
    int particleDelay = 20;
	SmokeParticleSystem particleSystem;

	MagmaRock(int x, int y)
	{    
		super(x, y);

		setupLightSource(this, 300, 1f);
		image = ResourceManager.getImage("LavaBlock");

		slipperiness = 0.1;
		healthMultiplier = 3f;
		setMaxHp(30);

		particleSystem = new SmokeParticleSystem(position, particleVelocity, particleDelay, false);
        load(particleSystem);
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

	void breakTile()
	{
		delete(particleSystem);

		super.breakTile();
	}
}
