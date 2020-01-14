class Explosion extends BaseObject
{
	private float maxRadius;
	private float maxDamage = 100;
	private float currentRadius = 0;
	private final float RADIUS_INCREASE = 35;

	private boolean dealDamageToPlayer;

	private ArrayList<BaseObject> objectsInMaxRadius;
	private ObjectFinderThread objectFinderThread;

	Explosion(PVector spawnPos, float radius, float maxDamage, boolean dealDamageToPlayer)
	{
		position.set(spawnPos);
		maxRadius = radius;
		this.maxDamage = maxDamage;
		this.dealDamageToPlayer = dealDamageToPlayer;

		//flash
		setupLightSource(this, radius, 1f);

		//get objects inside max range
		objectFinderThread = startObjectFinderThread(position, maxRadius);

		//create particle system
		ExplosionParticleSystem particleSystem = new ExplosionParticleSystem(position, int(radius / 3), radius / 15);
		load(particleSystem);

		//play sound
		String explosionSound = "Explosion" + floor(random(1, 5));
		AudioManager.playSoundEffect(explosionSound, position);
	}

	// find objects in range and deal dammage
	void explode()
	{
		if(objectFinderThread.isAlive())
		{
			// we are still getting the objects in max radius
			return;
		}
		else
		{
			if(objectsInMaxRadius == null)
			{
				objectsInMaxRadius = objectFinderThread.objectsInRadius;
			}
		}

		// find objects nearby
		ArrayList<BaseObject> objectsInCurrentExplosionRadius = new ArrayList<BaseObject>();

		for (BaseObject object : objectsInMaxRadius)
		{
			if (dist(position.x, position.y, object.position.x, object.position.y) < currentRadius)
			{
				objectsInCurrentExplosionRadius.add(object);
			}
		}

		// deal dammage to nearby objects
		for (BaseObject object : objectsInCurrentExplosionRadius)
		{
			if (!dealDamageToPlayer && object == player)
			{
				continue;
			}

			//damage falloff
			float damage = maxDamage - ((currentRadius / maxRadius) * maxDamage);

			if (object instanceof Tile)
			{
				Tile tileToDamage = (Tile)object;

				tileToDamage.takeDamage(damage, false);
			}
			else
			{
				object.takeDamage(damage);
			}
		}

		camera.induceStress(0.04f * TimeManager.deltaFix);

		// increase next explosion size
		currentRadius += RADIUS_INCREASE * TimeManager.deltaFix;

		if (currentRadius > maxRadius)
		{
			currentRadius = maxRadius;
		}
	}

	void update()
	{
		super.update();
		
		// only explode when we are smaller than the max radius
		if (currentRadius < maxRadius)
		{
			explode();
		}
		else
		{
			delete(this);
		}
	}
}
