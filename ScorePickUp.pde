public class ScorePickup extends Pickup
{
	private int score;
	private final float MAGNETDISTANCE = 50f;
	private float followSpeed = 10;

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

		//TODO: find and add sound effect, do not remove comment yet
		//RE: fuck you mr comment you broke the game by passing non-existant soundfiles. commented the playsound, uncomment when its fixed
		//AudioManager.playSoundEffect("Treasure", position);
		// Insert particle code here

		//Delete this object
		super.pickedUp(mob);
	}

	// void update()
	// {
	// 	super.update();
	// 	this.velocity.x = 20;

	// 	float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);

	// 	if (distanceToPlayer <= MAGNETDISTANCE)
	// 	{
	// 		float playerX = player.position.x;
	// 		float playerY = player.position.y;
			
	// 		if (this.position.y < playerY)
	// 		{
	// 			// this.gravityForce = chaseSpeed/2;//Go down
	// 		}
	// 		else
	// 		{
	// 			this.gravityForce = -followSpeed;//Go up
	// 		}
	// 	}
	// }

}
