class Explosion extends BaseObject
{
	float maxRadius;
	float maxDamage = 100;
	float currentRadius = 0;
	float radiusIncrease = 35;

	boolean dealDamageToPlayer;

	ArrayList<BaseObject> objectsInMaxRadius;
	ObjectFinderThread objectFinderThread;

	Explosion(PVector spawnPos, float radius, float maxDamage, boolean dealDamageToPlayer)
	{
		position.set(spawnPos);
		maxRadius = radius;
		this.maxDamage = maxDamage;
		this.dealDamageToPlayer = dealDamageToPlayer;

		//flash
		setupLightSource(this, radius, 1f);

		//get objects inside max range
		//objectsInMaxRadius = getObjectsInRadius(position, maxRadius);

		objectFinderThread = startObjectFinderThread(position, maxRadius);

		//create particle system
		ExplosionParticleSystem particleSystem = new ExplosionParticleSystem(position, int(radius / 3), radius / 15);
		load(particleSystem);

		//play sound
		String explosionSound = "Explosion" + floor(random(1, 5));
		AudioManager.playSoundEffect(explosionSound, position);
	}

	void explode()
	{
		if(objectFinderThread.isAlive())
		{
			// if we are still getting the objects in max radius
			return;
		}
		else
		{
			if(objectsInMaxRadius == null)
			{
				objectsInMaxRadius = objectFinderThread.objectsInRadius;
			}
		}

		ArrayList<BaseObject> objectsInCurrentExplosionRadius = new ArrayList<BaseObject>();

		for (BaseObject object : objectsInMaxRadius)
		{
			if (dist(position.x, position.y, object.position.x, object.position.y) < currentRadius)
			{
				objectsInCurrentExplosionRadius.add(object);
			}
		}

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

		camera.induceStress(0.04f);

		// increase next explosion size
		currentRadius += radiusIncrease * TimeManager.deltaFix;

		if (currentRadius > maxRadius)
		{
			currentRadius = maxRadius;
		}
	}

	void update()
	{
		super.update();

		if (currentRadius < maxRadius)
		{
			explode();
		}
		else
		{
			delete(this);
		}
	}

	void draw()
	{

	}

	void fade()
	{

	}
}
