public class AnimatedImage
{
	PImage[] frames;
	float frameDelay, objectWidth;
	PVector drawPosition;
	boolean flipSpriteHorizontal, isPaused;

	int frameCounter = 0;

	public AnimatedImage(PImage[] frames, float frameDelay, PVector drawPosition, float objectWidth, boolean flipSpriteHorizontal)
	{
		println("WARNING: Using legacy AnimatedImage, consider using the new constructor!");

		this.frames = frames;
		this.objectWidth = objectWidth;
		this.frameDelay = frameDelay;
		this.drawPosition = drawPosition;
		this.flipSpriteHorizontal = flipSpriteHorizontal;
	}

	public AnimatedImage(String animationName, int totalFrameCount, float frameDelay, PVector drawPosition, float objectWidth, boolean flipSpriteHorizontal)
	{
		frames = new PImage[totalFrameCount];

		for (int i = 0; i < totalFrameCount; i++)
		{
			frames[i] = ResourceManager.getImage(animationName + i); 
		}

		this.objectWidth = objectWidth;
		this.frameDelay = frameDelay;
		this.drawPosition = drawPosition;
		this.flipSpriteHorizontal = flipSpriteHorizontal;
	}

	public void draw()
	{
		pushMatrix();

		translate(drawPosition.x, drawPosition.y);

		int imageToDrawIndex = frameCounter / round(frameDelay) % frames.length;
		PImage imageToDraw = frames[imageToDrawIndex];

		if (flipSpriteHorizontal)
		{
			scale(-1, 1);
			image(imageToDraw, -objectWidth, 0);
		}
		else
		{
			image(imageToDraw, 0, 0);
		}

		popMatrix();

		// if this animation or the game is paused, return the function before it can increase the frame counter
		if (isPaused || gamePaused)
		{
			return;
		}

		frameCounter++;
	}

	public void resetCounter()
	{
		frameCounter = 0;
	}

	public void pauze()
	{
		isPaused = true;
	}

	public void resume()
	{
		isPaused = false;
	}
}
