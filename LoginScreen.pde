public class LoginScreen
{
    public String enteredName = "";

    private LoginLetter[] loginLetters;
    private String allChars = " ";
    private String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private String numbers = "1234567890";
    private int selectedCharIndex = 0;

    public LoginScreen()
    {
        setupChars();

        loginLetters = new LoginLetter[MAX_LOGIN_NAME_SIZE];

        for (int i = 0; i < loginLetters.length; i++)
        {
            loginLetters[i] = new LoginLetter(this, i, allChars);

            loginLetters[i].isEnabled = true;            
        }

        loginLetters[0].select();
    }

    private void setupChars()
    {
        allChars += alphabet;
        allChars += numbers;
    }
    
    public void update()
    {
        if(InputHelper.isKeyDown(RIGHT_KEY))
        {
            selectNextLetter();
            InputHelper.onKeyReleased(RIGHT_KEY);
        }

        if(InputHelper.isKeyDown(LEFT_KEY))
        {
            selectPreviousLetter();
            InputHelper.onKeyReleased(LEFT_KEY);
        }

        for (LoginLetter loginLetter : loginLetters)
        {
            loginLetter.update();
        }

        if(InputHelper.isKeyDown(START_KEY))
        {
            enteredName = getName();
            InputHelper.onKeyReleased(START_KEY);
        }
    }

    public void selectNextLetter()
    {
        if(selectedCharIndex >= MAX_LOGIN_NAME_SIZE - 1)
        {
            return;
        }

        loginLetters[selectedCharIndex].deselect();
        selectedCharIndex++;
        loginLetters[selectedCharIndex].select();
    }

    public void selectPreviousLetter()
    {
        if(selectedCharIndex <= 0)
        {
            return;
        }

        loginLetters[selectedCharIndex].deselect();
        selectedCharIndex--;
        loginLetters[selectedCharIndex].select();
    }

    public int getIndexByChar(char charToCheck)
    {
        for (int i = 0; i < allChars.length(); i++)
        {
            if(allChars.charAt(i) == charToCheck)
            {
                return i;
            }
        }

        return -1;
    }

    public String getName()
    {
        String fullName = "";

        for (LoginLetter loginLetter : loginLetters)
        {
            fullName += loginLetter.getChar();
        }

        return fullName.trim().toUpperCase();
    }

    public void draw()
    {
        background(0);

        drawTitle();

        for (LoginLetter loginLetter : loginLetters)
        {
            loginLetter.draw();
        }

        drawIndex();

        drawFooter();
    }

    private void drawTitle()
    {
        textAlign(CENTER);
        textSize(40);
        text("Please enter your name", width / 2, height / 7);
    }

    private void drawIndex()
    {
        textAlign(CENTER);
        textSize(30);
        text((selectedCharIndex + 1) + " / " + MAX_LOGIN_NAME_SIZE, width / 2, height / 4);
    }

    private void drawFooter()
    {
        textAlign(CENTER);
        textSize(40);
        text("Press ENTER to start playing", width / 2, height - (height / 7));
    }
}
