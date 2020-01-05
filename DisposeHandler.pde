public class DisposeHandler
{
	DisposeHandler(PApplet game)
	{
		game.registerMethod("dispose", this);
	}

	public void dispose()
	{
		// We can use this to check how long the game has been running
		databaseManager.registerSessionEnd();
		println("Closing sketch after " + (millis() / 1000) + " seconds (" + millis() + " ms)");
	}
}
