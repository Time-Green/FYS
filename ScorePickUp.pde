public class ScorePickup extends Pickup
{
	private int score;

	// drop based on tile
	public ScorePickup(ResourceTile tile)
	{
		this.score = tile.value / tile.pickupDropAmountValue;
		this.image = tile.pickupImage;
	}

	// independant drop
	public ScorePickup(int scoreToGiveOnPickup, PImage image)
	{
		this.score = scoreToGiveOnPickup;
		this.image = image;
	}

	//This Pickup is collected by the player
	void pickedUp(Mob mob)
	{
		//Score
		player.addScore(score);
		//Draw the Pickup text
		load(new PickupText(score, position));
		ui.drawExtraPoints(this.score);

		//Effects
		//TODO: find and add sound effect, do not remove comment yet
		// AudioManager.playSoundEffect(PickupSound, position);
		// Insert particle code here

		//Delete this object
		super.pickedUp(mob);
		
	}

}
