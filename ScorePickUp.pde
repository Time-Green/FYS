public class ScorePickup extends Pickup
{
	private int score;
	private float chaseDistance;

	//Drop based on tile
	public ScorePickup(ResourceTile tile)
	{
		score = tile.value / tile.pickupDropAmountValue;
		image = tile.pickupImage;

		setup();
	}

	//Independant drop
	public ScorePickup(int scoreToGiveOnPickup, PImage image)
	{
		score = scoreToGiveOnPickup;
		this.image = image;

		setup();
	}

	private void setup()
	{
		if(player == null) //depth is basically 0 anyway
		{
			return;
		}

		//Determine how many tiles we want the score pickup to chase the player
		float tileChaseDistance = 50f;
		chaseDistance = OBJECT_SIZE * tileChaseDistance;

		drawLayer = PRIORITY_LAYER;

		// Multiply score based on depth
		// Every 100 depth we add 10% to the score
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
		{//Add this score to the nearest pickup text
			nearbyPickupText.addScore(score, position);
		}
		else
		{
			//Create new Pickup text
			load(new PickupText(score, position));
		}
		
		// TODO: find and add sound effect, do not remove comment yet
		// AudioManager.playSoundEffect("Treasure", position);

		// Delete this object
		super.pickedUp(mob);
	}

	private PickupText findNearbyPickupText()
	{
		for (BaseObject object : updateList)
		{
			if(object instanceof PickupText && dist(position.x, position.y, object.position.x, object.position.y) < TILE_SIZE * 2.5f)
			{
				//Cast to PickUptext
				PickupText pickupText = (PickupText) object;

				if(!pickupText.isPowerupText)
				{
					return pickupText;
				}
			}
		}

		// if nothing was found, check the load list, it may have spawned on the same frame
		for (BaseObject object : loadList)
		{
			if(object instanceof PickupText && dist(position.x, position.y, object.position.x, object.position.y) < TILE_SIZE * 2.5f)
			{
				//Cast to PickUptext
				PickupText pickupText = (PickupText) object;

				if(!pickupText.isPowerupText)
				{
					return pickupText;
				}
			}
		}

		return null;
	}

	void update()
	{
		super.update();

		if (player.magnetTimer > 0)
		{//The magnet power up is active
			float defaultGravity = gravityForce;
			float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);

			if (distanceToPlayer <= chaseDistance)
			{// Go torwards the player if he is in range
				float moveSpeed = 15;
				this.collisionEnabled = false;
				this.gravityForce = 0;
				
				float playerX = player.position.x;
				float playerY = player.position.y;

				if (this.position.x > playerX)
				{// Go left
					this.velocity.x = -moveSpeed;
				}
				else
				{// Go right
					this.velocity.x = moveSpeed;
				}
				
				
				if (this.position.y < playerY)
				{//Go down
					this.velocity.y = moveSpeed;
				}
				else
				{//Go up
					this.velocity.y = -moveSpeed;
				}
			}
			else
			{// Return back to normal
				this.collisionEnabled = true;
				this.gravityForce = defaultGravity;
			}
		}
	}

}
