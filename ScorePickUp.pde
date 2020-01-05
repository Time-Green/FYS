public class ScorePickup extends Pickup
{
	private int score;
	//Placeholder sound
	private String soundName = "Treasure";

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
		ui.drawExtraPoints(score);

		//Effects
		//TODO: find and add sound effect, do not remove comment yet
		AudioManager.playSoundEffect(soundName, position);
		// Insert particle code here

		//Delete this object
		super.pickedUp(mob);
	}
}
