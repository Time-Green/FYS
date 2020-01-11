public class Camera
{
	private PVector position;
	private Movable target;
	private float lerpAmount;

	private final float SPAWN_Y_POS = 220;

	private PVector currentShakeOffset = new PVector();

	private float maxTraumaIntensity = 2f;

	// Maximum distance in each direction the transform
	// with translate during shaking.
	private PVector maximumShakeAmount = new PVector(30, 30);

	// Frequency of the Perlin noise function. Higher values
	// will result in faster shaking.
	private float frequency = 15;

	// Trauma is taken to this power before
	// shaking is applied. Higher values will result in a smoother
	// falloff as trauma reduces.
	private float traumaExponent = 1;

	// Amount of trauma per frame that is recovered.
	private float recoverySpeed = 0.04f;

	// Value between 0 and 1 defining the current amount
	// of stress this transform is enduring.
	private float trauma = 0;

	private float seed;

	public Camera(Movable targetObject)
	{
		position = new PVector();

		setTarget(targetObject);
		
		setupInitialValues();
	}

	private void setupInitialValues()
	{
		position.x = -target.position.x + width * 0.5f - target.size.x / 2f;

		if(gameState == GameState.GameOver)
		{
			position.y = -SPAWN_Y_POS * 5;
		}
		else
		{
			position.y = SPAWN_Y_POS;
		}
		
		lerpAmount = 0.001f;
	}

	public void setTarget(Movable targetObject)
	{
		target = targetObject;
	}

	public void update()
	{
		// if we dont have a target, do nothing
		if (target == null)
		{
			return;
		}

		updateShake();

		float targetX = -target.position.x + width * 0.5f - target.size.x / 2f;
		float targetY = -target.position.y + height * 0.5f - target.size.y / 2f;

		PVector targetPosition = new PVector(targetX, targetY);

		//targetPosition.x += -target.velocity.x * 15;

		// println(-target.velocity.y);

		// if(target.velocity.y >= 17.5f)
		// {
		// 	targetPosition.y -= target.velocity.y * 50;
		// }

		targetPosition.add(currentShakeOffset);

		position.lerp(targetPosition, lerpAmount);

		//limit x position so the camera doesent go to far to the left or right
		float minXposotion = -(TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE - width);
		position.x = constrain(position.x, minXposotion, 0);

		translate(position.x, position.y);
	}

	private void updateShake()
	{
		float shake = pow(trauma, traumaExponent);

		currentShakeOffset = new PVector(
		maximumShakeAmount.x * (noise(seed, millis() * 1000 * frequency) * 2 - 1), 
		maximumShakeAmount.y * (noise(seed + 1, millis() * 1000 * frequency) * 2 - 1)
		).mult(shake);

		trauma = constrain(trauma - recoverySpeed, 0, maxTraumaIntensity);
	}

	public PVector getPosition()
	{
		return position;
	}

	public void induceStress(float stress)
	{
		seed = random(1);
		trauma = constrain(trauma + stress, 0, maxTraumaIntensity);
	}

	public void setTrauma(float traumaToSet)
	{
		trauma = constrain(traumaToSet, 0, maxTraumaIntensity);
	}
}
