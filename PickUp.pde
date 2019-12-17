public class PickUp extends Movable
{
	boolean canTake = true; //in-case we need an override to stop people picking stuff up, like thrown dynamite

	PickUp()
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

			//maybe replace with canPickUp?
			if (canTake && mob.canPickUp(this))
			{
				pickedUp(mob);
				runData.pickUpsPickedUp++;

				return false;
			}
		}

		if (object instanceof PickUp) {
			return false;
		}

		return super.canCollideWith(object);
	}
}
