class ShieldPickup extends Pickup
{ 
    ShieldPickup()
    {
        image = ResourceManager.getImage("Shield");
    }

    void pickedUp(Mob mob)
	{
        float extraShieldTime = timeInSeconds(10f);
		player.shieldTimer += extraShieldTime;
        super.pickedUp(mob);
	}
}