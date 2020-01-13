class RegenPickup extends Pickup
{ 
    RegenPickup()
    {
        image = ResourceManager.getImage("Regen");
    }

    void pickedUp(Mob mob)
	{
        super.pickedUp(mob);

        float extraRegenTime = timeInSeconds(5f);

		player.extraRegenTimer += extraRegenTime;

        PickupText pickupText = new PickupText("+Regen", position);
        load(pickupText);
	}
}