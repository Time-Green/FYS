// expends BaseObject instead of Movable for perforamce
public class BaseParticle extends BaseObject
{
	// own position
	protected PVector velocity = new PVector();

	private BaseParticleSystem particleSystem;
	protected float size;
	private float spawnTime;

	protected float maxLifeTime = 120; //max 120 frames life time. it's a float so we can easily do certain divisions, like for opacity
	protected float currentLifeTime = 0;

	protected float minSize = 15;
	protected float maxSize = 30;

	protected color particleColor = color(255);

	public BaseParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnVelocity)
	{
		super();

		drawLayer = PRIORITY_LAYER;

		// many performance, such wow
		enableLightning = false;

		particleSystem = parentParticleSystem;

		position.set(spawnLocation);
		velocity.set(spawnVelocity);
		size = random(minSize, maxSize);
		spawnTime = millis();
	}

	void update()
	{
		if(gamePaused)
		{
			return;
		}

		super.update();

		PVector deltaFixVelocity = PVector.mult(velocity, TimeManager.deltaFix);

		position.add(deltaFixVelocity);

		//if the particle is to old..
		if (currentLifeTime > maxLifeTime)
		{
			cleanup();
		}

		currentLifeTime += TimeManager.deltaFix;
	}

	void draw()
	{
		if (!inCameraView())
		{
			return;
		}

		fill(particleColor);
		tint(lightningAmount);

		pushMatrix();

		translate(position.x, position.y);
		rect(0, 0, size, size);
		
		popMatrix();

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
