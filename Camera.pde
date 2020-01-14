public class Camera
{
	private PVector position; // current position
	private PVector targetPosition; // where we need to go
	private Movable target;
	private float lerpAmount;

	private final float SPAWN_Y_POS = 220;

	// the current amount of camera shake to be applied
	private PVector currentShakeOffset = new PVector();

	// the max amount of trauma
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

	// to make sure the cameashake is differnet every time
	private float seed;

	public Camera(Movable targetObject)
	{
		position = new PVector();
		targetPosition = new PVector();

		setTarget(targetObject);
		
		setupInitialValues();
	}

	// sets up the correct position
	private void setupInitialValues()
	{
		position.x = -target.position.x + width * 0.5f - target.size.x / 2f;

		if(gameState == GameState.GameOver)
		{
			position.y = -SPAWN_Y_POS * 3;
		}
		else
		{
			position.y = SPAWN_Y_POS;
		}
		
		lerpAmount = 0.001f;
	}

	// change the object we are looking at
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

		// update position based on the target
		float targetX = -target.position.x + width * 0.5f - target.size.x / 2f;
		float targetY = -target.position.y + height * 0.5f - target.size.y / 2f;

		targetPosition.set(targetX, targetY);

		// apply camera shake
		targetPosition.add(currentShakeOffset);

		// smootly move towards the target based on distance
		position.lerp(targetPosition, lerpAmount * TimeManager.deltaFix);

		//limit x position so the camera doesent go to far to the left or right
		float minXposotion = -(TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE - width);
		position.x = constrain(position.x, minXposotion, 0);

		translate(position.x, position.y);
	}

	// calculate the camera shake
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

	// add more stress for when camera shake is needed
	public void induceStress(float stress)
	{
		seed = random(1);
		trauma = constrain(trauma + stress, 0, maxTraumaIntensity);
	}

	// instantly set the trauma to directly update the camera shake amount
	public void setTrauma(float traumaToSet)
	{
		trauma = constrain(traumaToSet, 0, maxTraumaIntensity);
	}
}
