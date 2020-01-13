class ShieldPickup extends Pickup
{ 
    ShieldPickup()
    {
        image = ResourceManager.getImage("Shield");
    }

    void pickedUp(Mob mob)
	{
        super.pickedUp(mob);

        float extraShieldTime = timeInSeconds(10f);

		player.shieldTimer += extraShieldTime;

        PickupText pickupText = new PickupText("+Shield", position);
        load(pickupText);
	}
}