class MagnetPickup extends Pickup
{ 
    MagnetPickup()
    {
        image = ResourceManager.getImage("Magnet");
    }

    void pickedUp(Mob mob)
	{
        super.pickedUp(mob);

        float extraMagnetTime = timeInSeconds(10f);

		player.magnetTimer += extraMagnetTime;
        
        PickupText pickupText = new PickupText("+Magnet", position);
        load(pickupText);
	}
}