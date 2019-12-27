public class Pickup extends Movable
{
	boolean canTake = true; //in-case we need an override to stop people picking stuff up, like thrown dynamite

	Pickup()
	{ 
		size.set(30, 30);
	}

	void pickedUp(Mob mob)
	{
		delete(this);
	}

	boolean canCollideWith(BaseObject object)
	{
		if (object instanceof Mob)
		{
			Mob mob = (Mob) object;

			//maybe replace with canPickup?
			if (canTake && mob.canPickup(this))
			{
				pickedUp(mob);
				runData.pickupsPickedUp++;

				return false;
			}
		}

		if (object instanceof Pickup) {
			return false;
		}

		return super.canCollideWith(object);
	}
}
