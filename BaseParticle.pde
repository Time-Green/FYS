public class BaseParticle extends Movable
{
	BaseParticleSystem particleSystem;
	PVector spawnAcceleration;
	float size, spawnTime;

	float maxLifeTime = 2000; //max 2 seconds life time

	float minSize = 15;
	float maxSize = 30;

	color particleColor = color(255);

	public BaseParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
		super();

		gravityForce = 0.0f;
		collisionEnabled = false;
		worldBorderCheck = false;
		groundedDragFactor = 1.0f;
		aerialDragFactor = 1.0f;

		// many performance, such wow
		enableLightning = false;

		spawnAcceleration = spawnAcc;
		particleSystem = parentParticleSystem;

		position.set(spawnLocation);
		acceleration.set(spawnAcceleration);
		size = random(minSize, maxSize);
		spawnTime = millis();
	}

	void update()
	{
		super.update();

		//if the particle is to old..
		if (millis() > spawnTime + maxLifeTime)
		{
			cleanup();
		}
	}

	void draw()
	{
		if (!inCameraView())
		{
			return;
		}

		fill(particleColor);
		tint(lightningAmount);

		rect(position.x - size / 2, position.y - size / 2, size, size);

		fill(255);
		tint(255);
	}

	void cleanup()
	{
		particleSystem.currentParticleAmount--;
		delete(this);
	}

	void takeDamage(float damageTaken)
	{
		// don't take any damage
	}
}
