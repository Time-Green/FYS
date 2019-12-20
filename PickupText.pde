public class PickupText extends BaseObject
{
	private int score;
	private PFont textFont;
	private float aliveTime = timeInSeconds(3f);

	public PickupText(int drawScore, PVector currentPos)
	{
		drawLayer = FRONT;

		score = drawScore;
		position.set(currentPos);
	}

	void draw()
	{
		textAlign(CENTER);
		textSize(20);
		fill(#ffffff);

		//Draw the score text
		text("+" + score, position.x, position.y);

		position.y--;
		
		//Decrease the alive counter and remove the text when it is 0
		aliveTime--;

		if (aliveTime <= 0)
		{
			delete(this);
		}
	}
} 
