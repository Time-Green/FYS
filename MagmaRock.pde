class MagmaRock extends Tile
{
	//we want enough damage so the player won't mine trough it
	float damage = 18;

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
		setMaxHp(40);

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

	void breakTile(boolean generated)
	{
		delete(particleSystem);

		super.breakTile(generated);
	}
}
