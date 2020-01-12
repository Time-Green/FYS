class RegenPickup extends Pickup
{ 
    RegenPickup()
    {
        image = ResourceManager.getImage("Regen");
    }

    void pickedUp(Mob mob)
	{
        float extraRegenTime = timeInSeconds(5f);
		player.extraRegenTimer += extraRegenTime;
        super.pickedUp(mob);
	}
}