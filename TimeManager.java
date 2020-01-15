import processing.core.*;

public class TimeManager
{
    private static PApplet game;

    private static float targetFramerate; //standard 1000, framerate that the game tries to run at
    private static float currentGameSpeed; //standard 60, used to speed up or slow down the game without changing the framerate
    private static float targetGameSpeed;

    //this is what you use to keep everything moving at the same speed, no matter the framerate
    public static float deltaFix;
    public static float deltaFixFrameCount;
    public static int flooredDeltaFixFrameCount;
    private static float previousMilli, deltaDiv;

    private static boolean drawFps, drawFpsGraph;

    private static boolean isInBulletTime;
    private static float bulletTimeComebackSeconds;

    //used for framerate graph
    private static float[] frameRateHistory;
    private static int currentGraphLine = 0;

    //set PApplet, framerate and gameSpeed, has to be called in the main setup function!
    public static void setup(PApplet pApplet, float targetFps, Float gameSpeed, boolean showFps, boolean showFpsGraph)
    {
        game = pApplet;

        setTargetFrameRate(targetFps);
        setGameSpeed(gameSpeed, true);

        drawFps = showFps;
        drawFpsGraph = showFpsGraph;
        
        if(drawFpsGraph)
        {
            frameRateHistory = new float[game.width];
        }
        
        currentGameSpeed = gameSpeed;
        targetGameSpeed = gameSpeed;
        previousMilli = game.millis();
    }

    //has to be called in the main draw function!
    public static void update()
    {
        int millis = game.millis();

        deltaDiv = previousMilli / millis;
        deltaFix = (currentGameSpeed / game.frameRate) * deltaDiv;

        deltaFixFrameCount += deltaFix;
        flooredDeltaFixFrameCount = game.floor(deltaFixFrameCount);

        previousMilli = millis;

        if(isInBulletTime)
        {
            handleBulletTime();
        }

        if(drawFps)
        {
            drawFps();
        }

        if(drawFpsGraph)
        {
            drawFrameRateGraph();
        }
    }

    private static void handleBulletTime()
    {
        if(currentGameSpeed < targetGameSpeed)
        {
            currentGameSpeed += targetGameSpeed / currentGameSpeed * deltaFix / bulletTimeComebackSeconds;
        }

        if(currentGameSpeed > targetGameSpeed)
        {
            currentGameSpeed = targetGameSpeed;
            isInBulletTime = false;
        }
    }

    private static void drawFps()
    {
        game.textAlign(game.LEFT);
        game.textSize(15);
        game.text("FPS: (" + game.round(targetFramerate) + ") " + game.round(game.frameRate) + "\nGameSpeed: (" + targetGameSpeed + ") " + currentGameSpeed + "\nDeltaFix: " + deltaFix, 10, 20);
    }

    private static void drawFrameRateGraph()
    {
        if(currentGraphLine < frameRateHistory.length - 1)
        {
            //go to next graph line
            currentGraphLine++;
        }
        else
        {
            //scroll graph
            for(int i = 0; i < frameRateHistory.length; i++)
            {
                if(i + 1 < frameRateHistory.length)
                {
                    frameRateHistory[i] = frameRateHistory[i + 1];
                }
            }
        }

        //insert data into graph
        frameRateHistory[currentGraphLine] = game.frameRate;

        //draw
        for(int i = 0; i < frameRateHistory.length; i++)
        {
            float currentGraphFrameRate = frameRateHistory[i];

            if(currentGraphFrameRate >= 60)
            {
                game.fill(0, 255, 0, 127);
            }
            else if(currentGraphFrameRate >= 30)
            {
                game.fill(255, 140, 0, 127);
            }
            else
            {
                game.fill(255, 0, 0, 127);
            }

            game.rect(i, game.height - currentGraphFrameRate, 1, currentGraphFrameRate);
        }

        game.fill(255);
    }

    //set the framerate that the game tries to run at
    public static void setTargetFrameRate(float targetFps)
    {
        targetFramerate = targetFps;
        game.frameRate(targetFramerate);
    }

    //set the game speed
    public static void setGameSpeed(float speed, boolean alsoUpdateTargetGameSpeed)
    {
        currentGameSpeed = speed;

        if(alsoUpdateTargetGameSpeed)
        {
            targetGameSpeed = speed;
        }

        if(currentGameSpeed < 0)
        {
            currentGameSpeed = 0;
        }

        if(targetGameSpeed < 0)
        {
            targetGameSpeed = 0;
        }
    }

    //adds/removes a specific amount to the game speed
    public static void addGameSpeed(float amount)
    {
        targetGameSpeed += amount;
        currentGameSpeed += amount;

        if(targetGameSpeed < 0)
        {
            targetGameSpeed = 0;
        }

        if(currentGameSpeed < 0)
        {
            currentGameSpeed = 0;
        }
    }

    public static void startBulletTime(float slowToSpeed, float comebackSeconds)
    {
        isInBulletTime = true;
        bulletTimeComebackSeconds = comebackSeconds;
        setGameSpeed(slowToSpeed, false);
    }
}
