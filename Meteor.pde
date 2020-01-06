class Meteor extends Movable
{
	private final float MAXHORIZONTALVELOCITY = 12.0;
	private final float MINSIZE = 1.0;
	private final float MAXSIZE = 4.0;
	private final float BRIGHTNESS = 300;

	private float sizeModifier;

	MeteorTrailParticleSystem particleSystem;

	Meteor()
	{
		worldBorderCheck = false;
		rotateTowardsHeading = true;

		sizeModifier = random(MINSIZE, MAXSIZE);
		size.set(TILE_SIZE * sizeModifier, TILE_SIZE * sizeModifier);

		aerialDragFactor = 1.0f;
		gravityForce = 0.75f - map(sizeModifier, MINSIZE, MAXSIZE, -0.55f, 0.25f);

		velocity.set(random(-MAXHORIZONTALVELOCITY, MAXHORIZONTALVELOCITY), 0);
		image = ResourceManager.getImage("Meteor 2");

		particleSystem = new MeteorTrailParticleSystem(position, 3.75f, 1, true, size);
		load(particleSystem, position);

		setupLightSource(this, BRIGHTNESS, 1f);
	}

	void update()
	{
		if (gamePaused)
		{  
			return;
		}

		super.update(); 

		updateParticleSystemPosition();

		if (isGrounded)
		{
			load(new Explosion(position, 100 * sizeModifier, 50, true));
			delete(particleSystem);
			delete(this);
		}
		else if (position.x < -size.x / 2 || position.x > world.getWidth() + size.x / 2)
		{
			delete(particleSystem);
			delete(this);
		}
	}

	private void updateParticleSystemPosition()
	{
		particleSystem.position.x = position.x + size.x / 2;
		particleSystem.position.y = position.y + size.y / 2;
	}
}
