public class LoginLetter
{
    public boolean isEnabled = false;

    private LoginScreen loginScreen;
    private boolean isSelected = false;
    private float atIndex;
    private PVector drawPosition;
    private String allChars;
    private int charIndex = 0;

    private int displayCounter = 0;

    public LoginLetter(LoginScreen loginScreen, int index, String allChars)
    {
        this.loginScreen = loginScreen;
        atIndex = float(index);
        this.allChars = allChars;

        drawPosition = new PVector(calculateXPos(), height / 2);
    }

    public void update()
    {
        if(!isEnabled)
        {
            return;
        }

        drawPosition.y = height / 2;
        drawPosition.x = calculateXPos();

        if(isSelected)
        {
            checkInput();
        }
    }

    public void draw()
    {
        if(!isEnabled)
        {
            return;
        }

        drawBackground();

        if(isSelected)
        {
            rect(drawPosition.x - 25, drawPosition.y + 15, 50, 10);
            displayCounter++;

            drawArrows();
        }

		if (displayCounter >= 0)
		{
            textAlign(CENTER);
            textSize(70);

			text(getChar(), drawPosition.x, drawPosition.y);

			if(displayCounter > 40)
			{
				displayCounter = -40;
			}
		}
    }

    private void drawBackground()
    {
        rectMode(CENTER);
        fill(255, 50);

        rect(drawPosition.x, drawPosition.y - 25, 50, 80);

        rectMode(CORNER);
        fill(255);
    }

    private void drawArrows()
    {
        textAlign(CENTER);
        textSize(70);

        text("↑", drawPosition.x, drawPosition.y - 110);
        text("↓", drawPosition.x, drawPosition.y + 110);

        textAlign(CENTER);
        textSize(40);

        if(atIndex > 0)
        {
            text("←", drawPosition.x - 45, drawPosition.y - 10);
        }

        if(atIndex < MAX_LOGIN_NAME_SIZE - 1)
        {
            text("→", drawPosition.x + 45, drawPosition.y - 10);
        }
    }

    private void checkInput()
    {
        if(InputHelper.isKeyDown(UP))
        {
            charIndex++;
            displayCounter = 0;

            if(charIndex > allChars.length() - 1)
            {
                charIndex = 0;
            }

            InputHelper.onKeyReleased(UP);
        }

        if(InputHelper.isKeyDown(DOWN))
        {
            charIndex--;
            displayCounter = 0;

            if(charIndex < 0)
            {
                charIndex = allChars.length() - 1;
            }

            InputHelper.onKeyReleased(DOWN);
        }
    }

    public void select()
    {
        isSelected = true;
        displayCounter = 0;
    }

    public void deselect()
    {
        isSelected = false;
        displayCounter = 0;
    }

    private float calculateXPos()
    {
        float xPos = 0.0f;
        float offset = (((atIndex + 0.5) / float(loginScreen.activeChars)) - 0.5f);
        float offsetMultiplier = width / 4f + loginScreen.activeChars * 42; // 42, it was the answer all along!

        // multiply offset based on schreen width
        offset *= offsetMultiplier;

        // offset text based on index
        xPos += offset;

        // center text
        xPos += width / 2;

        return xPos;
    }

    public char getChar()
    {
        return allChars.charAt(charIndex);
    }

}
