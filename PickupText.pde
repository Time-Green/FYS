public class PickupText extends BaseObject
{
	private int score;
	private float aliveTime = timeInSeconds(3f);

	private AnimatedImage stars;

	//Text
	private PFont textFont;
	private color textColor = #ffffff;
	private final int FONTSIZE = 20;

	public PickupText(int drawScore, PVector currentPos)
	{
		drawLayer = PRIORITY_LAYER;

		score = drawScore;
		position.set(currentPos);

		//Set up the animation
		int numberOfSprites = 4;
		int animationSpeed = 8;
		stars = new AnimatedImage("PickupParticle", numberOfSprites, animationSpeed, position, size.x, false);
	}

	void draw()
	{
		if (gamePaused)
		{
			return;
		}

		textAlign(CENTER);
		textSize(FONTSIZE);
		fill(textColor);

		//Draw the score text
		text("+" + score, position.x, position.y);

		tint(random(0f, 255f), random(0f, 255f), random(0f, 255f));
		stars.draw();
		tint(255);
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
