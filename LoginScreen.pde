public class LoginScreen
{
    private final int MIN_CHARS_TO_DISPLAY = 6;

    public String enteredName = "";
    public int activeChars = MIN_CHARS_TO_DISPLAY;

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

            if(i < MIN_CHARS_TO_DISPLAY)
            {
                loginLetters[i].isEnabled = true;
            }
        }

        loginLetters[0].select();
    }

    private void setupChars()
    {
        String lowerCaseAlphabet = alphabet.toLowerCase();

        allChars += alphabet;
        allChars += lowerCaseAlphabet;
        allChars += numbers;
    }
    
    public void update()
    {
        if(InputHelper.isKeyDown(RIGHT_KEY) && selectedCharIndex < MAX_LOGIN_NAME_SIZE - 1)
        {
            if(selectedCharIndex > activeChars - 3 && activeChars < MAX_LOGIN_NAME_SIZE)
            {
                loginLetters[activeChars].isEnabled = true;
                activeChars++;
            }

            loginLetters[selectedCharIndex].deselect();
            selectedCharIndex++;
            loginLetters[selectedCharIndex].select();

            InputHelper.onKeyReleased(RIGHT_KEY);
        }

        if(InputHelper.isKeyDown(LEFT_KEY) && selectedCharIndex > 0)
        {
            for (int i = activeChars - 1; i > MIN_CHARS_TO_DISPLAY; i--)
            {
                if(loginLetters[i].isEnabled && loginLetters[i].getChar() != ' ')
                {
                    break;
                }

                loginLetters[i].isEnabled = false;
                loginLetters[i].deselect();
                activeChars--;

                selectedCharIndex = activeChars - 1;
            }

            loginLetters[selectedCharIndex].deselect();
            selectedCharIndex--;
            loginLetters[selectedCharIndex].select();

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

    public String getName()
    {
        String fullName = "";

        for (LoginLetter loginLetter : loginLetters)
        {
            fullName += loginLetter.getChar();
        }

        return fullName.trim();
    }

    public void draw()
    {
        background(0);

        drawTitle();

        for (LoginLetter loginLetter : loginLetters)
        {
            loginLetter.draw();
        }

        drawFooter();
    }

    private void drawTitle()
    {
        textAlign(CENTER);
        textSize(40);
        text("Please enter your name", width / 2, height / 7);
    }

    private void drawFooter()
    {
        textAlign(CENTER);
        textSize(40);
        text("Press ENTER to start playing", width / 2, height - (height / 7));
    }
}
