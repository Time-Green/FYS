public class ScorePickup extends Pickup
{
	private int score;
	private final float MAGNETDISTANCE = 50f;
	private float followSpeed = 10;

	// drop based on tile
	public ScorePickup(ResourceTile tile)
	{
		score = tile.value / tile.pickupDropAmountValue;
		image = tile.pickupImage;

		multiplyScoreBasedOnDepth();
	}

	// independant drop
	public ScorePickup(int scoreToGiveOnPickup, PImage image)
	{
		score = scoreToGiveOnPickup;
		this.image = image;

		multiplyScoreBasedOnDepth();
	}

	private void multiplyScoreBasedOnDepth()
	{
		// every 100 depth we add 10% to the score
		float multiplier = float(player.getDepth()) / 1000f;

		score *= 1 + multiplier;
	}

	// This Pickup is collected by the player
	void pickedUp(Mob mob)
	{
		// Score
		player.addScore(score);
		ui.drawExtraPoints(score);

		PickupText nearbyPickupText = findNearbyPickupText();

		if(nearbyPickupText != null)
		{
			nearbyPickupText.addScore(score, position);
		}
		else
		{
			//Create new Pickup text
			load(new PickupText(score, position));
		}
		
		// TODO: find and add sound effect, do not remove comment yet
		// RE: fuck you mr comment you broke the game by passing non-existant soundfiles. commented the playsound, uncomment when its fixed
		// AudioManager.playSoundEffect("Treasure", position);
		// Insert particle code here

		// Delete this object
		super.pickedUp(mob);
	}

	private PickupText findNearbyPickupText()
	{
		for (BaseObject object : updateList)
		{
			if(object instanceof PickupText && dist(position.x, position.y, object.position.x, object.position.y) < TILE_SIZE * 2.5f)
			{
				PickupText pickupText = (PickupText) object;

				return pickupText;
			}
		}

		// if nothing was found, check the load list, it may have spawned on the same frame
		for (BaseObject object : loadList)
		{
			if(object instanceof PickupText && dist(position.x, position.y, object.position.x, object.position.y) < TILE_SIZE * 2.5f)
			{
				PickupText pickupText = (PickupText) object;

				return pickupText;
			}
		}

		return null;
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
