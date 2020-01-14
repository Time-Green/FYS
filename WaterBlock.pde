public class WaterBlock extends SlowFallTile
{
    float damage = 8;

    	public WaterBlock(int x, int y)
	{
		super(x, y);

		density = true; //we are dense so we can distinguish ourselves from other blocks and draw the decals
		//drawLayer = ABOVE_TILE_LAYER; 

		image = ResourceManager.getImage("WaterBlock");
	}
    
    //we want to give the player a chilled effect
	void collidedWith(BaseObject object)
	{
		object.takeDamage(damage);

		if(object instanceof Mob)
		{
			Mob mob = (Mob) object;

			mob.setChilled();
		}
	}
}