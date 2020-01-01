public class ItemParticle extends BaseParticle
{
    Item item; //the item we're "mimicking"

    PVector uiLocation; //location of the inventory slot we're targetting, store it so we dont have to constantly call it
    int targetSlot; //the inventory slot that we are going to

    float speedCoefficient = 0.05; //we take the difference between us and the target and then do that times this for the speed, kinda difficult to put into a varname

	public ItemParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc, Item item)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);

        this.item = item;
        //get the location of the first empty inventory slot on our screen;
        targetSlot = player.getFirstEmptyInventorySlot();
        uiLocation = ui.getInventorySlotLocation(targetSlot);

        size = 2;
	}

	void update()
	{
		super.update();

        PVector targetLocation = new PVector().set(uiLocation);
        //since we're drawn before the camera translates, we need to update the UI locatin relative to the camera. Camera pos is reversed so minus it
        targetLocation.add(-camera.position.x, -camera.position.y); 

        velocity.x = (targetLocation.x - position.x) * speedCoefficient;
        velocity.y = (targetLocation.y - position.y) * speedCoefficient;

        if(dist(position.x, position.y, targetLocation.x, targetLocation.y) < ui.inventorySize)
        {
            terminate();
        }
	}

	void draw()
	{
		if (!inCameraView())
		{
			return;
		}

        image(item.image, position.x, position.y, item.size.x * size, item.size.y * size);
    }

    void terminate()
    {
        player.inventoryDrawable[targetSlot] = true;
        delete(this);
    }
}
