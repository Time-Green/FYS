public class PickupText extends BaseObject
{
	private int score;
	private float aliveTime = timeInSeconds(3f);

	//Text
	private PFont textFont;
	private color textColor = #ffffff;
	private final int FONTSIZE = 20;

	public PickupText(int drawScore, PVector currentPos)
	{
		drawLayer = PRIORITY_LAYER;

		score = drawScore;
		position.set(currentPos);
	}

	void draw()
	{
		textAlign(CENTER);
		textSize(FONTSIZE);
		fill(textColor);

		//Draw the score text
		text("+" + score, position.x, position.y);
	}

	void update() {
		
		//Decrease the alive counter and remove the text when it is 0
		aliveTime--;

		if (aliveTime <= 0)
		{
			delete(this);
		}
	}
} 
