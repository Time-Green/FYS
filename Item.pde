class Item extends Pickup
{
	float throwSpeed = SPEED_LIMIT; // throw speed, for when you use it
	Mob thrower; // whoever threw us, if we're even throwable

	float cooldown = 0;
	float takeAfter = 300; // time till we can pick stuff up after throwing them

	Item()
	{
		image = ResourceManager.getImage("DiamondPickup");
	}

	void update()
	{
		super.update();

		// I dislike needing this, but there really isnt another way me thinks
		if (cooldown != 0 && cooldown < millis())
		{
			canTake = true;
			thrower = null;
			cooldown = 0;
		}
	}

	boolean canCollideWith(BaseObject baseObject)
	{
		// lets not instantly collide with whoever threw us 
		if (baseObject == thrower)
		{
			return false;
		}

		return super.canCollideWith(baseObject);
	}

	void pickedUp(Mob mob)
	{
		if (!suspended && mob.canAddToInventory(this))
		{
			mob.addToInventory(this);
		}
	}

	void onUse(Mob mob)
	{
		mob.removeFromInventory(this);
		int direction;

		if(mob.flipSpriteHorizontal) //sprite defaults to pointing left, so if this is true he's standing still and looking to the right
		{
			direction = RIGHT;
		}

		else
		{
			direction = LEFT;
		}

		throwItem(mob, direction);

		return;
	}

	void throwItem(Mob mob, int direction)
	{
		position.set(mob.position);

		switch(direction)
		{

			case UP:
				velocity.set(0, -throwSpeed);
			break;

			case DOWN:
				velocity.set(0, throwSpeed);
			break;

			case LEFT:
				velocity.set(-throwSpeed, 0);
			break;

			case RIGHT:
				velocity.set(throwSpeed, 0);
			break;
		}

		canTake = false;
		canTakeAfter(takeAfter);
		thrower = mob;
	}

	void drawOnPlayer(Player mob)
	{

	}

	void canTakeAfter(float timer)
	{
		cooldown = millis() + timer;
	}
}
