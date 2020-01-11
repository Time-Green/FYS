public class LoginLetter
{
    public boolean isEnabled = false;

    private LoginScreen loginScreen;
    private boolean isSelected = false;
    private boolean canGetInput = false;
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

        if(!canGetInput && !keyPressed)
        {
            canGetInput = true;
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
            drawNearbyChars();
        }

		if (displayCounter >= 0)
		{
            textAlign(CENTER);
            textSize(50);

			text(getChar(), drawPosition.x + 2, drawPosition.y);

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

    private void drawNearbyChars()
    {
        for (int i = -3; i < 4; i++)
        {
            if(i != 0)
            {
                fill(255, 255 - abs(i * 75));
                text(getChar(i), drawPosition.x, drawPosition.y + i * 70);
            }
        }

        fill(255);
    }

    private void checkInput()
    {
        if(InputHelper.isKeyDown(DOWN))
        {
            charIndex++;
            displayCounter = 0;

            if(charIndex > allChars.length() - 1)
            {
                charIndex = 0;
            }

            InputHelper.onKeyReleased(DOWN);
        }
        else if(InputHelper.isKeyDown(UP))
        {
            charIndex--;
            displayCounter = 0;

            if(charIndex < 0)
            {
                charIndex = allChars.length() - 1;
            }

            InputHelper.onKeyReleased(UP);
        }
        else if(canGetInput && keyPressed && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT && keyCode != SHIFT)
        {
            if(keyCode == BACKSPACE)
            {
                charIndex = 0;
                loginScreen.selectPreviousLetter();
            }
            else
            {
                String tempChar = "";

                tempChar += key;
                tempChar = tempChar.toUpperCase();

                int index = loginScreen.getIndexByChar(tempChar.charAt(0));

                if(index >= 0)
                {
                    charIndex = index;
                    displayCounter = 0;
                    loginScreen.selectNextLetter();
                }
            }
        }
    }

    public void select()
    {
        canGetInput = false;
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
        float offset = (((atIndex + 0.5) / float(MAX_LOGIN_NAME_SIZE)) - 0.5f);
        float offsetMultiplier = width / 4f + MAX_LOGIN_NAME_SIZE * 42; // 42, it was the answer all along!

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

    public char getChar(int offset)
    {
        int index = charIndex + offset;

        if(index < 0)
        {
            index = allChars.length() + index;
        }

        if(index > allChars.length() - 1)
        {
            index = index - allChars.length();
        }

        return allChars.charAt(index);
    }
}
