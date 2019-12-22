public class ScorePickUp extends PickUp
{
	private int score;

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
		//Score
		player.addScore(score);
		//Draw the pickup text
		load(new PickupText(score, position));
		ui.drawExtraPoints(this.score);

		//Effects
		//TODO: find and add sound effect, do not remove comment yet
		// AudioManager.playSoundEffect(pickupSound, position);
		// Insert particle code here

		//Delete this object
		super.pickedUp(mob);
		
	}

}
