class MagnetPickup extends Pickup
{ 
    MagnetPickup()
    {
        image = ResourceManager.getImage("Magnet");
    }

    void pickedUp(Mob mob)
	{
        float extraMagnetTime = timeInSeconds(10f);
		player.magnetTimer += extraMagnetTime;
        super.pickedUp(mob);
	}
}