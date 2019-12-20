public class ScorePickUp extends PickUp
{
	int score;
	boolean pickedUp;

	// drop based on tile
	public ScorePickUp(ResourceTile tile)
	{
		this.score = tile.value / tile.pickUpDropAmountValue;
		this.image = tile.pickUpImage;
	}

	// independant drop
	public ScorePickUp(int scoreToGiveOnPickup, PImage image)
	{
		this.score = scoreToGiveOnPickup;
		this.image = image;
	}

	//This pickup is collected by the player
	void pickedUp(Mob mob)
	{
		if (!pickedUp) //The player hasn't collected this puckup yet
		{
			player.addScore(score);
			load(new PickupText(score, position));
			//Prevent the player from picking us up again
			// pickedUp = true;
			//TODO: find and add sound effect, do not remove comment yet
			// AudioManager.playSoundEffect(pickupSound, position);

			//I'm keeping this around until i'm done with the pickup rework
			super.pickedUp(mob);
		}
		
	}

	void update() 
	{

		//This pickup has been collected by the player
		if (pickedUp)
		{
			collisionEnabled = false;
			gravityForce = 0;
			position.x-=5;
			position.y-=5;
		}
		else 
		{
			super.update();
		}
	}
}
