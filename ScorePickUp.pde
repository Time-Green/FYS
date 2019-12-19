public class ScorePickUp extends PickUp
{
	int score;

	// drop based on tile
	public ScorePickUp(ResourceTile tile)
	{
		score = tile.value / tile.pickUpDropAmountValue;
		image = tile.pickUpImage;
	}

	// independant drop
	public ScorePickUp(int scoreToGiveOnPickup, PImage image)
	{
		score = scoreToGiveOnPickup;
		this.image = image;
	}

	//This pickup is collected by the player
	void pickedUp(Mob mob)
	{
		player.addScore(score);
		load(new PickupText(score, position));
		//TODO: find and add sound effect, do not remove comment yet
		// AudioManager.playSoundEffect(pickupSound, position);

		super.pickedUp(mob);
	}
}
