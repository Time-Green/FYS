public class PickupText extends BaseObject
{
	private int score;
	private float aliveTime = timeInSeconds(2f);

	private AnimatedImage stars;

	//Text
	private PFont textFont;
	private color textColor = #ffffff;
	private final int BASE_FONT_SIZE = 15;
	private float fontSizeMultiplier = 1;

	public PickupText(int drawScore, PVector currentPos)
	{
		drawLayer = PRIORITY_LAYER;

		score = drawScore;
		position.set(currentPos);

		//Set up the animation
		final int NUMBER_OF_SPRITES = 4;
		final int ANIMATION_SPEED = 8;

		stars = new AnimatedImage("PickupParticle", NUMBER_OF_SPRITES, ANIMATION_SPEED, position, size.x, false);
	}

	void draw()
	{
		if (gamePaused)
		{
			return;
		}

		textAlign(CENTER);
		fontSizeMultiplier = map(score, 0f, 10000f, 1f, 3f);
		textSize(BASE_FONT_SIZE * fontSizeMultiplier);
		fill(textColor);

		//Draw the score text
		text("+" + score, position.x, position.y);

		tint(random(0f, 255f), random(0f, 255f), random(0f, 255f));
		stars.draw();
		tint(255);
	}

	public void addScore(int scoreToAdd, PVector newPickupLocation)
	{
		score += scoreToAdd;
		aliveTime = timeInSeconds(2f);
		position = PVector.lerp(position, newPickupLocation, 0.5f);
		stars.drawPosition.set(position);
	}

	void update() {

		if (gamePaused)
		{
			return;
		}
		
		//Decrease the alive counter and remove the text when it is 0
		if (aliveTime <= 0)
		{
			delete(this);
		}
	}
} 
